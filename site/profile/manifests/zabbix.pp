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
  # Resource title is 'zabbix' (confirmed via the agent run log showing
  # Yumrepo[zabbix]) - the Zabbix_<majorrelease>_<arch> string is only the
  # repo's name/descr, which is what the inifile provider names the file after.
  # gpgkey must be one newline-joined string, not an array - yumrepo's gpgkey
  # isn't array_matching(:all), so an array is treated as "any of these values
  # is in sync" and only ever writes the first element.
  Yumrepo <| title == 'zabbix' |> {
    gpgkey => "https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-08EFA7DD\n       https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005",
  }
}
