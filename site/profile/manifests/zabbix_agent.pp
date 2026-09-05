# zabbix agent
#
# Linux nodes install from the Zabbix repo that the module manages. Windows has
# no such repo, so the vendor MSI is staged on disk first and installed from
# there.
#
# @param version the zabbix release branch, used for the Linux repo packages
# @param server the zabbix servers this agent accepts checks from
# @param msi_version the exact agent build installed on Windows
# @param msi_checksum sha256 of the Windows MSI
# @param msi_base_url vendor location the Windows MSI is fetched from
class profile::zabbix_agent (
  String[1]       $version      = '7.0',
  String[1]       $server       = 'monit.preda.ca,127.0.0.1',
  String[1]       $msi_version  = '7.0.29',
  String[1]       $msi_checksum = '64199cc1cf68e9f562eb55020a8aaeebc52056b5f70f08f660ab8c84c4f7ef30',
  Stdlib::HTTPUrl $msi_base_url = 'https://cdn.zabbix.com/zabbix/binaries/stable',
) {
  if $facts['os']['family'] == 'windows' {
    # The MSI registers the service with --config pointing inside its own
    # install folder, so every path the module manages has to point back into
    # it. The module's C:/ProgramData/zabbix defaults would be written but
    # never read by the service.
    $install_dir = 'C:/Program Files/Zabbix Agent'
    $msi_file    = "zabbix_agent-${msi_version}-windows-amd64-openssl.msi"
    $msi_path    = "C:/Windows/Temp/${msi_file}"

    archive { $msi_path:
      ensure        => present,
      source        => "${msi_base_url}/${version}/${msi_version}/${msi_file}",
      checksum      => $msi_checksum,
      checksum_type => 'sha256',
      extract       => false,
      before        => Class['zabbix::agent'],
    }

    class { 'zabbix::agent':
      zabbix_version          => $msi_version,
      server                  => $server,
      # The MSI adds its own inbound rule for ListenPort, and the module's
      # firewall support is iptables-only anyway.
      manage_firewall         => false,
      # Default on Windows is chocolatey, which would pull in another module
      # and a third-party package feed.
      manage_choco            => false,
      zabbix_package_provider => 'windows',
      zabbix_package_source   => $msi_path,
      # Must match the MSI's ARP display name, otherwise the package is
      # reinstalled on every run.
      zabbix_package_agent    => 'Zabbix Agent (64-bit)',
      agent_configfile_path   => "${install_dir}/zabbix_agentd.conf",
      include_dir             => "${install_dir}/zabbix_agentd.d",
      logfile                 => "${install_dir}/zabbix_agentd.log",
    }
  } else {
    # EL10's selinux-policy ships no zabbix types at all, so the module's
    # zabbix-agent.te - which opens with `require { type zabbix_agent_t; }` -
    # fails to load with "Failed to resolve typeattributeset statement", and
    # that takes Service[zabbix-agent] down with it. The agent runs unconfined
    # there, so the policy module has nothing to grant.
    $manage_selinux = versioncmp($facts['os']['release']['major'], '10') < 0

    class { 'zabbix::agent':
      zabbix_version  => $version,
      server          => $server,
      manage_firewall => false,
      manage_selinux  => $manage_selinux,
    }

    # zabbix::repo hardcodes RPM-GPG-KEY-ZABBIX-08EFA7DD for EL9, but 7.0
    # packages are actually signed with RPM-GPG-KEY-ZABBIX-B5333005. Same
    # gap as profile::zabbix - see the collector override there for details.
    Yumrepo <| title == 'zabbix' |> {
      gpgkey => "https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD\n       https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005",
    }
  }
}
