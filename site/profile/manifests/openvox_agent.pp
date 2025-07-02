# profile puppet agent
class profile::openvox_agent {
  class { 'puppet': puppet_runinterval => '2h',  agent_server_hostname => 'puppet.preda.ca' }
}
