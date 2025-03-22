# Zabbix Agent 2 on Windows
#
class profile::zabbix_windows {
  $tmpdir = $facts['windows_env']['TMP'];

  download_file { 'get zabbix-installer.msi':
    url                   => 'https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.39/zabbix_agent2_plugins-6.0.39-windows-amd64.msi',
    destination_directory => $tmpdir,
    destination_file      => 'zabbix_agent2_plugins-6.0.39-windows-amd64.msi',
  }

  class { 'zabbix::agent':
    zabbix_version          => $zabbix_version,
    manage_resources        => true,
    manage_choco            => false,
    zabbix_package_agent    => 'Zabbix Agent 2 (64-bit)',
    zabbix_package_state    => present,
    zabbix_package_provider => 'windows',
    zabbix_package_source   => "${tmpdir}/zabbix_agent2_plugins-6.0.39-windows-amd64.msi",
  }
}
