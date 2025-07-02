# profile puppet agent
class profile::openvox_agent {
  class { 'puppet':
    runinterval         => '2h',
  agent_server_hostname => 'puppet.preda.ca' }
}
