# zabbix db server
class profile::zabbix_db {
  package { 'mariadb-server':
    ensure           => installed,
    service_name     => 'mysqld',
    root_password    => 'AVeryStrongPasswordUShouldEncrypt!',
    override_options => {
      'mysqld' => {
        'bind_address' => '172.16.10.19',
      },
    },
  }
  class { 'zabbix::database':
    database_type => 'mysql',
    zabbix_server => 'monitor.preda.ca',
    zabbix_web    => 'monitor.preda.ca',
  }
}
