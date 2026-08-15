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
    database_host     => 'db.preda.ca',
    database_name     => 'zabbixdb',
    database_user     => 'zabbix_user',
    database_type     => 'postgresql',
    database_password => $database_password,
  }
}
