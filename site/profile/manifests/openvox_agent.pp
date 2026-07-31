# Install openvox agent using the foreman puppet module
# use hiera per node or per os family
# @param release the openvox release to use, default 8
# @param agent_server the puppet server to connect to, default puppet.preda.ca
class profile::openvox_agent (
  Integer $release      = 8,
  String  $agent_server = 'puppet.preda.ca',
) {
  $is_windows = $facts['os']['family'] == 'windows'

  # Repo setup is RPM-only. On Windows the OpenVox agent MSI is installed at
  # build time (see win-srv1-ci/setup.ps1), so there is no repo to add and no
  # package for the module to manage - only puppet.conf and the service.
  unless $is_windows {
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
  }

  class { 'puppet':
    runinterval           => 3600,
    runmode               => 'service',
    agent_server_hostname => $agent_server,
    manage_packages       => !$is_windows,
  }
}
