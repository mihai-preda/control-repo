# zabbix server profile
class profile::zabbix {
  class { 'zabbix::web':
    manage_vhost       => true,
    zabbix_server_name => '',
    zabbix_url         => 'monit.preda.ca',
    database_name      => 'zabbixdb',
    database_user      => 'zabbix_user',
    database_password  => 'Burninator@1',
    zabbix_timezone    => 'America/Vancouver',
    manage_repo        => true,
    zabbix_version     => '6.0',
    apache_use_ssl     => true,
    database_host      => 'db.preda.ca',
    database_type      => 'postgresql',
    apache_ssl_cert    => '/etc/pki/tls/certs/monit.preda.ca-cert.pem',
    apache_ssl_key     => '/etc/pki/tls/private/monit.preda.ca-key.pem',
    apache_ssl_chain   => '/etc/pki/tls/certs/monit.preda.ca-chain.pem',
  }
  class { 'apache::mod::ssl': }
  class { 'postgresql::client': }
  class { 'zabbix::server':
    database_host     => 'db.preda.ca',
    database_name     => 'zabbixdb',
    database_user     => 'zabbix_user',
    database_type     => 'postgresql',
    database_password => 'Burninator@1',
  }
  firewalld_port { '10050/tcp':
    ensure   => present,
    zone     => 'public',
    service  => 'zabbix-agent',
    protocol => 'tcp',
  }
  firewalld_port { '10051/tcp':
    ensure   => present,
    zone     => 'public',
    service  => 'zabbix-server',
    protocol => 'tcp',
  }
}
