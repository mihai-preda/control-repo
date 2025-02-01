# zabbix db server
class profile::zabbixdb {
  class { 'zabbix::database':
    database_type     => 'postgresql',
    manage_database   => true,
    zabbix_web_ip     => '172.16.1.13',
    zabbix_server_ip  => '172.16.1.13',
    database_user     => 'zabbix_user',
    database_password => 'Burninator@1',
    database_name     => 'zabbixdb',
  }
  firewall { '200 allow zabbix server access to pgsql':
    dport => [5432],
    proto => 'tcp',
    jump  => 'accept',
  }
}
