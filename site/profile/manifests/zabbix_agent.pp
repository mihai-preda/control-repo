# zabbix agent
class profile::zabbix_agent {
  class { 'zabbix::agent':
    zabbix_version  => '7.0',
    server          => 'monitor.preda.ca',
    manage_firewall => true,
  }
}
