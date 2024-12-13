# Class: profile::zabbix_server
node 'monitor.preda.ca' {
  class { 'apache':
    mpm_module => 'prefork',
  }
  class { 'zabbix':
    zabbix_url    => 'monitor.preda.ca',
    database_type => 'mysql',
  }
  if $facts['os']['selinux']['enabled'] {
    selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
      persistent => true,
      value      => 'on',
    }
  }
}
