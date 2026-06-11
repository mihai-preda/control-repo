# zabbix db server
# @param database_password - the password for the zabbix database user
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
  firewall { '200 allow zabbix server access to pgsql':
    dport => [5432],
    proto => 'tcp',
    jump  => 'accept',
  }
}
