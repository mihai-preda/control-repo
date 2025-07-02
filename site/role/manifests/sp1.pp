# role server physical 1
class role::sp1 {
  include profile::openvox_agent
  include profile::resolver
  #include profile::zabbix_agent
}
