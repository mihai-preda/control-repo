# zabbix server profile
# @param database_password - the password for the zabbix database user
class profile::zabbix (
  String $database_password,
) {
  class { 'zabbix::web':
    manage_vhost       => true,
    zabbix_server_name => 'monit.preda.ca',
    zabbix_url         => 'monit.preda.ca',
    database_name      => 'zabbixdb',
    database_user      => 'zabbix_user',
    database_password  => $database_password,
    zabbix_timezone    => 'America/Vancouver',
    manage_repo        => true,
    zabbix_version     => '7.0',
    apache_use_ssl     => true,
    database_host      => 'db.preda.ca',
    database_type      => 'postgresql',
    apache_ssl_cert    => "/etc/letsencrypt/live/${facts['networking']['fqdn']}/cert.pem",
    apache_ssl_key     => "/etc/letsencrypt/live/${facts['networking']['fqdn']}/privkey.pem",
    apache_ssl_chain   => "/etc/letsencrypt/live/${facts['networking']['fqdn']}/chain.pem",
    require            => Class['profile::certificates'],
  }
  class { 'apache::mod::ssl': }
  class { 'postgresql::client': }
  class { 'zabbix::server':
    zabbix_version       => '7.0',
    zabbix_package_state => 'latest',
    database_host        => 'db.preda.ca',
    database_name        => 'zabbixdb',
    database_user        => 'zabbix_user',
    database_type        => 'postgresql',
    database_password    => $database_password,
  }

  # zabbix::repo hardcodes RPM-GPG-KEY-ZABBIX-08EFA7DD for EL9, but the 7.0
  # server packages are actually signed with RPM-GPG-KEY-ZABBIX-B5333005.
  # There's no module parameter for this, so override the yumrepo it declares.
  # Title is the module's computed "Zabbix_<majorrelease>_<arch>" string, not
  # 'zabbix' - confirmed from the deployed /etc/yum.repos.d/*.repo filename.
  # Collector queries don't support =~, so match the computed title exactly.
  Yumrepo <| title == "Zabbix_${facts['os']['release']['major']}_${facts['os']['architecture']}" |> {
    gpgkey => [
      'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD',
      'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005',
    ],
  }
}
