# Tomcat manifests file
# @param source_url - the URL to download the Tomcat package from
#
# The 8443 connector serves a self-signed cert on purpose: this backend is
# meant to sit behind an httpd front-end that terminates real (public) TLS, so
# the proxy->Tomcat hop stays encrypted (a common Cybersecurity mandate). The
# cert is a plain PEM pair generated with the openssl CLI, so no openssl Puppet
# module is needed. Tomcat 11 requires a nested SSLHostConfig, which the tomcat
# module emits when given the cert_*_file parameters.
class profile::tomcat (
  String $source_url,
) {
  $cert = '/opt/tomcat/conf/tomcat-selfsigned.crt'
  $key  = '/opt/tomcat/conf/tomcat-selfsigned.key'
  $fqdn = $facts['networking']['fqdn']

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

  # Self-signed PEM cert + key for the TLS connector. openssl ships with the
  # base OS, so this needs no openssl Puppet module. Idempotent via `creates`.
  exec { 'tomcat-selfsigned-cert':
    command  => "/usr/bin/openssl req -x509 -newkey rsa:2048 -nodes -keyout ${key} -out ${cert} -days 3650 -subj '/CN=${fqdn}/OU=Lab/O=Preda/L=Delta/ST=British Columbia/C=CA' -addext 'subjectAltName=DNS:${fqdn}'",
    creates  => $cert,
    provider => 'shell',
    path     => ['/usr/bin', '/bin'],
    require  => Tomcat::Install['/opt/tomcat'],
  }

  file { $key:
    ensure  => file,
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0600',
    require => Exec['tomcat-selfsigned-cert'],
  }

  file { $cert:
    ensure  => file,
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0644',
    require => Exec['tomcat-selfsigned-cert'],
  }

  # TLS connector. The cert_*_file params make the module emit the nested
  # SSLHostConfig/Certificate that Tomcat 11 requires; attributes_to_remove
  # strips the deprecated connector-level keystore* attributes Tomcat rejects.
  tomcat::config::server::connector { 'https':
    catalina_base         => '/opt/tomcat',
    port                  => '8443',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'SSLEnabled' => 'true',
      'scheme'     => 'https',
      'secure'     => 'true',
    },
    attributes_to_remove  => ['keystoreFile', 'keystorePass', 'keystoreType', 'clientAuth', 'sslProtocol'],
    cert_key_file         => $key,
    cert_file             => $cert,
    cert_chain_file       => $cert,
    cert_type             => 'RSA',
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
      File[$key],
      File[$cert],
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
