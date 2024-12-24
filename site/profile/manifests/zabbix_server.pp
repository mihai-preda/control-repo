# zabbix server
node 'monitor.preda.ca' {
  class { 'apache':
    mpm_module => 'prefork',
  }
  class { 'apache::mod::php': }
  class { 'mysql::client': }
  class { 'zabbix::server': }
  class { 'zabbix::web':
    zabbix_url    => 'monitor.preda.ca',
    database_type => 'mysql',
    database_host => 'zdb.preda.ca',
  }
  if $facts['os']['selinux']['enabled'] {
    selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
      persistent => true,
      value      => 'on',
    }
  }
}
