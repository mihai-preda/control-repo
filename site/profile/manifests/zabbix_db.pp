# zabbix db server
class profile::zabbix_db {
  class { 'mysql::server':
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
