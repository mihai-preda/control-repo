# Install openvox agent using the foreman puppet module
# use hiera per node or per os family
class profile::openvox_agent (
  Integer $release      = 8,
  String  $agent_server = 'puppet.preda.ca',
) {
  include yum
  $os_name = $facts['os']['name'] ? {
    'Fedora' => 'fedora',
    'Amazon' => 'amazon',
    default  => 'el',
  }

  yum::install { "openvox${release}-release":
    ensure => 'present',
    source => "https://yum.voxpupuli.org/openvox${release}-release-${os_name}-${facts['os']['release']['major']}.noarch.rpm",
  }
  class { 'puppet': runinterval => 3600, runmode => 'service', agent_server_hostname => $agent_server }
}
