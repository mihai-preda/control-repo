# zabbix server
# the db_host and db_type variables have to be declared
# in both sections below for successful connection
class profile::zabbix {
  class { 'zabbix::web':
    manage_vhost     => true,
    zabbix_url       => 'monitor.preda.ca',
    manage_repo      => true,
    zabbix_version   => '6.0',
    apache_use_ssl   => true,
    database_host    => 'zdb.preda.ca',
    database_type    => 'mysql',
    apache_ssl_cert  => '/etc/pki/tls/certs/cert.pem',
    apache_ssl_key   => '/etc/pki/tls/private/privatekey.pem',
    apache_ssl_chain => '/etc/pki/tls/certs/chain.pem',
  }
  class { 'apache::mod::ssl': }
  class { 'mysql::client': }
  class { 'zabbix::server':
    database_host           => 'zdb.preda.ca',
    database_name           => 'zabbixdb',
    database_type           => 'mysql',
    database_user           => 'zabbixuser',
    database_password       => 'Burninator@1',
    remove_default_accounts => true,
  }
  firewall { '100 allow zabbix agent and zabbix server access':
    dport => [10050, 10051],
    proto => 'tcp',
    jump  => 'accept',
  }
}
