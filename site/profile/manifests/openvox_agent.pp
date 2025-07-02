# profile puppet agent
class profile::openvox_agent {
  class { 'puppet': runmode => 'cron', agent_server_hostname => 'puppet.preda.ca' }
}
