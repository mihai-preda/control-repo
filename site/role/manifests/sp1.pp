# role server physical 1
class role::sp1 {
  #include profile::zabbix_agent
  include profile::resolver
  include openvox_repo
}
