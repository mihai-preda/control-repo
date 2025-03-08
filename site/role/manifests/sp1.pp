# role server physical 1
class role::sp1 {
  include profile::puppet_agent
  include profile::zabbix_agent
}
