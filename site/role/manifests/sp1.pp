# role server physical 1
class role::sp1 {
  include profile::base
  include profile::puppetserver
  include profile::zabbix_agent
}
