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
    zabbix_version     => '6.0',
    apache_use_ssl     => true,
    database_host      => 'db.preda.ca',
    database_type      => 'postgresql',
    apache_ssl_cert    => '/etc/pki/tls/certs/monit.preda.ca-cert.pem',
    apache_ssl_key     => '/etc/pki/tls/private/monit.preda.ca-key.pem',
    apache_ssl_chain   => '/etc/pki/tls/certs/monit.preda.ca-chain.pem',
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
