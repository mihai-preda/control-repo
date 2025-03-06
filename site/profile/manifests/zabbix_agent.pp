# zabbix agent
class profile::zabbix_agent {
  class { 'zabbix::agent':
    zabbix_version  => '6.0',
    server          => 'monitor.preda.ca,127.0.0.1',
    manage_firewall => true,
  }
}
