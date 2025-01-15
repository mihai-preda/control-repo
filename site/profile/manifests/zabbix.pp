# zabbix server
class profile::zabbix {
  class { 'zabbix::web':
    zabbix_url        => 'monitor.preda.ca',
    database_type     => 'mysql',
    database_user     => 'zabbix',
    database_password => 'Burninator@1',
    manage_repo       => true,
    zabbix_version    => '6.0',
  }
  class { 'apache::mod::ssl': }
  class { 'mysql::client': }
  class { 'zabbix::server':
    database_host => 'zdb.preda.ca',
    database_type => 'mysql',
  }
  class { 'default-ssl':
    port              => 443,
    ssl               => true,
    default_ssl_cert  => '/etc/pki/tls/certs/cert.pem',
    default_ssl_key   => '/etc/pki/tls/private/privatekey.pem',
    default_ssl_chain => '/etc/pki/tls/certs/chain.pem',
  }
}
