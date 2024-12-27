# zabbix agent
class profile::puppet_agent {
  class { 'zabbix::agent':
    zabbix_version  => '7.0',
    server          => 'monitor.preda.ca',
    manage_firewall => true,
  }
}
