# install openvox agent
class openvox_repo (
  Integer $release = 8,
) {
  include yum

  $os_name = $facts['os']['name'] ? {
    'Fedora'  => 'fedora',
    'Amazon'  => 'amazon',
    default   => 'el',
  }

  yum::install { "openvox${release}-release":
    ensure => 'present',
    source => "https://yum.voxpupuli.org/openvox${release}-release-${os_name}-${facts['os']['release']['major']}.noarch.rpm",
  }
}
