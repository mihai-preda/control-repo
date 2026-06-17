# Tomcat manifests file
# @param source_url - the URL to download the Tomcat package from
class profile::tomcat (
  String $source_url,
) {
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

  tomcat::config::server::connector { 'default':
    catalina_base         => '/opt/tomcat',
    port                  => '8081',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => '8443',
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
    subscribe => Tomcat::Config::Server::Connector['default'],
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
