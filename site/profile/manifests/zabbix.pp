# zabbix server profile
class profile::zabbix {
  class { 'zabbix::web':
    manage_vhost      => true,
    zabbix_url        => 'monitor.preda.ca',
    database_name     => 'zabbixdb',
    database_user     => 'zabbix_user',
    database_password => 'Burninator@1',
    zabbix_timezone   => 'America/Vancouver',
    manage_repo       => true,
    zabbix_version    => '6.0',
    apache_use_ssl    => true,
    database_host     => 'db.preda.ca',
    database_type     => 'postgresql',
    apache_ssl_cert   => '/etc/pki/tls/certs/cert.pem',
    apache_ssl_key    => '/etc/pki/tls/private/privatekey.pem',
    apache_ssl_chain  => '/etc/pki/tls/certs/chain.pem',
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
  firewall { '100 allow zabbix agent and zabbix server access':
    dport => [10050, 10051],
    proto => 'tcp',
    jump  => 'accept',
  }
}
