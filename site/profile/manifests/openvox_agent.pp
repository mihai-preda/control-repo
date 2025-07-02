# profile puppet agent
class profile::openvox_agent {
  class { 'puppet': runinterval => '2h',runmode => 'systemd.timer', agent_server_hostname => 'puppet.preda.ca' }
}
