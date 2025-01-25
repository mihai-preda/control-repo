# zabbix db server
class profile::zabbixdb {
  class { 'postgresql::server':
    listen_addresses  => '0.0.0.0',
  }
  class { 'zabbix::database':
    database_type     => 'postgresql',
    manage_database   => true,
    zabbix_web_ip     => '172.16.10.13',
    zabbix_server_ip  => '172.16.10.13',
    database_user     => 'zabbix_user',
    database_password => 'Burninator@1',
    database_name     => 'zabbixdb',
  }
}
