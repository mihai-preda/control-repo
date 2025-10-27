# role server physical 1
class role::sp1 {
  include profile::base
  include profile::resolver
  include profile::openvox_agent
}
