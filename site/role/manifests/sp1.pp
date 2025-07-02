# role server physical 1
class role::sp1 {
  include profile::puppet_agent
  include profile::resolver
  #include profile::zabbix_agent
}
