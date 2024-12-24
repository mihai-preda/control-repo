# zabbix server
class profile::zabbix {
  class { 'zabbix':
    zabbix_url        => 'monitor.preda.ca',
    database_type     => 'mysql',
    database_user     => 'zabbix',
    database_password => 'QuertY#1',
  }
  class { 'apache':
    mpm_module => 'prefork',
  }
  class { 'apache::mod::php': }
  class { 'zabbix::web':
  }
  if $facts['os']['selinux']['enabled'] {
    selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
      persistent => true,
      value      => 'on',
    }
  }
}
