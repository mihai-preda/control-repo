# Tomcat manifests file
# @param source_url - the URL to download the Tomcat package from
# @param keystore_password - password for the self-signed TLS keystore Tomcat
#   serves on 8443. Self-signed is intentional: this backend sits behind an
#   httpd front-end that terminates real (public) TLS, so the proxy->Tomcat hop
#   is still encrypted (a common Cybersecurity mandate). Override via Hiera.
class profile::tomcat (
  String $source_url,
  String $keystore_password = 'changeit',
) {
  $keystore = '/opt/tomcat/conf/tomcat-selfsigned.p12'
  $fqdn     = $facts['networking']['fqdn']

  package { 'java-17-openjdk-headless':
    ensure => 'present',
  }

  tomcat::install { '/opt/tomcat':
    source_url => $source_url,
  }

  # The service is managed by the systemd unit below, so the tomcat module must
  # not declare its own exec-based service for this single instance.
  tomcat::instance { 'default':
    catalina_home  => '/opt/tomcat',
    manage_service => false,
  }

  # Plain HTTP connector; 8443 is its redirect target for secured resources.
  tomcat::config::server::connector { 'default':
    catalina_base         => '/opt/tomcat',
    port                  => '8081',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => '8443',
    },
  }

  # Self-signed TLS keystore for the 8443 connector. keytool ships with the JDK,
  # so this needs no openssl module. Idempotent via `creates`.
  exec { 'tomcat-selfsigned-keystore':
    command  => "/usr/bin/keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 -validity 3650 -storetype PKCS12 -keystore ${keystore} -storepass '${keystore_password}' -dname 'CN=${fqdn}, OU=Lab, O=Preda, L=Delta, ST=British Columbia, C=CA' -ext SAN=dns:${fqdn}",
    creates  => $keystore,
    provider => 'shell',
    path     => ['/usr/bin', '/bin'],
    require  => [Tomcat::Install['/opt/tomcat'], Package['java-17-openjdk-headless']],
  }

  file { $keystore:
    ensure  => file,
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0600',
    require => Exec['tomcat-selfsigned-keystore'],
  }

  # TLS connector serving the self-signed cert.
  tomcat::config::server::connector { 'https':
    catalina_base         => '/opt/tomcat',
    port                  => '8443',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'SSLEnabled'   => 'true',
      'scheme'       => 'https',
      'secure'       => 'true',
      'keystoreFile' => $keystore,
      'keystorePass' => $keystore_password,
      'keystoreType' => 'PKCS12',
      'clientAuth'   => 'false',
      'sslProtocol'  => 'TLS',
    },
  }

  # A source install ships no service unit, so Tomcat would not survive a
  # reboot. Manage a systemd unit so it is enabled and started at boot.
  file { '/etc/systemd/system/tomcat.service':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profile/tomcat.service',
    notify => Exec['tomcat-systemd-daemon-reload'],
  }

  exec { 'tomcat-systemd-daemon-reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  service { 'tomcat':
    ensure    => running,
    enable    => true,
    require   => [
      Tomcat::Install['/opt/tomcat'],
      Package['java-17-openjdk-headless'],
      File['/etc/systemd/system/tomcat.service'],
      Exec['tomcat-systemd-daemon-reload'],
    ],
    subscribe => [
      Tomcat::Config::Server::Connector['default'],
      Tomcat::Config::Server::Connector['https'],
      File[$keystore],
    ],
  }

  # This node runs firewalld, so open the Tomcat ports with firewalld_port
  # rather than the iptables `firewall` type, which has no persistence here.
  firewalld_port { 'tomcat-http':
    ensure   => present,
    zone     => 'public',
    port     => 8081,
    protocol => 'tcp',
  }

  firewalld_port { 'tomcat-https':
    ensure   => present,
    zone     => 'public',
    port     => 8443,
    protocol => 'tcp',
  }
}
