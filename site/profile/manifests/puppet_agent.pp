# profile puppet agent
class profile::puppet_agent {
  class { 'puppet_agent':
    package_version => '8.10.0',
    collection      => 'puppet8',
    config          => [{ section => main, setting => runinterval, value => '1h' }],
  }
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
}
