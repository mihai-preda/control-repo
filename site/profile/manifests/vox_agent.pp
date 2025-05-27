# install openvox agent
class profile::vox_agent {
  package { 'openvox-agent':
    ensure => 'present',
  }
}
