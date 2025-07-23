# open_vox
class profile::openvox_agent {
  include yum
  $release=8
  $os_name = $facts['os']['name'] ? {
    'Fedora' => 'fedora',
    'Amazon' => 'amazon',
    default  => 'el',
  }

  yum::install { "openvox${release}-release":
    ensure => 'present',
    source => "https://yum.voxpupuli.org/openvox${release}-release-${os_name}-${facts['os']['release']['major']}.noarch.rpm",
  }
  class { 'puppet': runinterval => '2h', runmode => 'systemd.timer', agent_server_hostname => 'puppet.preda.ca' }
}
