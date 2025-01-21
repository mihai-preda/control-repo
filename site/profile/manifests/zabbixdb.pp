# zabbix db server
class profile::zabbixdb {
  $override_options = {
    'mysqld' => {
      'port' => '3306',
      'bind-address' => '0.0.0.0',
      'datadir' => '/var/lib/mysql',
      'socket' => '/var/lib/mysql/mysql.sock',
      'log-error' => '/var/log/mariadb/mariadb.log',
      'pid-file' => '/run/mariadb/mariadb.pid',
    },
  }
  class { 'mysql::server':
    package_name            => 'mariadb-server',
    create_root_user        => true,
    root_password           => '$trongBad#1',
    restart                 => true,
    reload_on_config_change => true,
    override_options        => $override_options,
    remove_default_accounts => true,
  }
  firewall { '201 allow mysql clients to connect':
    dport => 3306,
    proto => 'tcp',
    jump  => 'accept',
  }
  class { 'zabbix::database':
    database_type => 'mysql',
    zabbix_server => 'monitor.preda.ca',
    zabbix_web    => 'monitor.preda.ca',
  }
}
