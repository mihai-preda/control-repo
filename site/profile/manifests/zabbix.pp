# zabbix server
class profile::zabbix {
  class { 'zabbix::web':
    zabbix_url        => 'monitor.preda.ca',
    database_type     => 'mysql',
    database_user     => 'zabbix',
    database_password => 'Burninator@1',
    manage_repo       => true,
    zabbix_version    => '7.0',
  }
  class { 'apache::mod::ssl': }
  class { 'mysql::client': }
  class { 'zabbix::server':
    database_host => 'zdb.preda.ca',
    database_type => 'mysql',
  }
}
