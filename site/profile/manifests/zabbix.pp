# zabbix server
class profile::zabbix {
  class { 'zabbix::web':
    zabbix_url        => 'monitor.preda.ca',
    database_type     => 'mysql',
    database_user     => 'zabbix',
    database_password => 'Burninator@1',
  }
  class { 'apache::mod::ssl': }
  class { 'mysql::client': }
  class { 'zabbix::server':
    database_host => 'zdb.preda.ca',
    database_type => 'mysql',
  }
  if $facts['os']['selinux']['enabled'] {
    selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
      persistent => true,
      value      => 'on',
    }
  }
}
