# zabbix db server
class profile::zabbixdb {
  class { 'postgresql::server':
    listen_addresses => '172.16.10.14',
  }
  class { 'zabbix::database':
    database_type    => 'postgresql',
    zabbix_web_ip    => '172.16.10.13',
    zabbix_server_ip => '172.16.10.13',
  }
}
