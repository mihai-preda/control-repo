# profile puppet agent
class profile::openvox_agent {
  class { 'puppet': runmode => 'systemd.timer', runinterval => '2h',  agent_server_hostname => 'puppet.preda.ca' }
}
