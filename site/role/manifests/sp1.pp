# role server physical 1
class role::sp1 {
  include profile::base
  include profile::certificates
  include profile::resolver
  include profile::openvox_agent
  include profile::zabbix_agent
  include firewalld
  include accounts
  include profile::nfs_client
  include profile::libvirt_bridge
  include profile::cockpit
  include epel
  include profile::packages
}
