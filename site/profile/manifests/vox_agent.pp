# install openvox agent
class profile::vox_agent {
  package { 'opevox8-release':
    ensure   => 'present',
    provider => rpm,
    source   => 'https://yum.voxpupuli.org/openvox8-release-fedora-41.noarch.rpm',
  }
  package { 'openvox-agent':
    ensure => 'present',
  }
}
