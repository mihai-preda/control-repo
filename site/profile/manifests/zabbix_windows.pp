# Zabbix Agent 2 on Windows
#
class profile::zabbix_windows {
  class zabbix_agent::windows (
    String $download_url  = 'https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.39/zabbix_agent-6.0.39-windows-amd64.zip', # URL of the zip file
    String $install_dir   = 'C:\\Program Files\\Zabbix Agent',     # Installation directory
    String $config_file   = 'C:\\Program Files\\Zabbix Agent\\zabbix_agentd.conf',
    String $service_name  = 'Zabbix Agent',
    String $zabbix_server = 'monitor.preda.ca',                       # Zabbix server IP or hostname
  ) {
    # Ensure temporary directory exists
    file { 'C:\\temp':
      ensure => directory,
    }

    # Download the zip file
    exec { 'Download Zabbix Agent Zip':
      command  => "Invoke-WebRequest -Uri '${download_url}' -OutFile 'C:\\temp\\zabbix_agent.zip'",
      unless   => "Test-Path 'C:\\temp\\zabbix_agent.zip'",
      provider => powershell,
    }

    # Extract the zip file
    exec { 'Extract Zabbix Agent':
      command  => "Expand-Archive -Path 'C:\\temp\\zabbix_agent.zip' -DestinationPath '${install_dir}'",
      unless   => "Test-Path '${install_dir}\\zabbix_agentd.exe'",
      provider => powershell,
      require  => Exec['Download Zabbix Agent Zip'],
    }

    # Create the configuration file
    file { $config_file:
      ensure  => file,
      content => "Server=${zabbix_server}",
    }

    # Start and enable the Zabbix Agent service
    exec { 'Register Zabbix Agent Service':
      command => "${install_dir}\\zabbix_agentd.exe --install",
      unless  => "Test-Service '${service_name}'",
      require => Exec['Extract Zabbix Agent'],
    }

    service { $service_name:
      ensure  => running,
      enable  => true,
      require => Exec['Register Zabbix Agent Service'],
    }
  }
}
