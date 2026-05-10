# zabbix db server
class profile::zabbixdb (
  String $database_password,
) {
  class { 'zabbix::database':
    database_type     => 'postgresql',
    manage_database   => true,
    zabbix_web_ip     => '10.21.2.13',
    zabbix_server_ip  => '10.21.2.13',
    database_user     => 'zabbix_user',
    database_password => $database_password,
    database_name     => 'zabbixdb',
  }
  firewalld_port { 'postgresql':
    ensure   => present,
    zone     => 'public',
    port     => 5432,
    protocol => 'tcp',
  }
}
