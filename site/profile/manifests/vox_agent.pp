# install openvox agent
include yum
# class profile::vox_agent
class profile::vox_agent {
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
}
