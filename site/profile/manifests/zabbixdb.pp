# zabbix db server
class profile::zabbixdb {
  $override_options = {
    'mysqld' => {
      'port' => 3306,
      'socket' => '/tmp/mysql.sock',
      'back_log' => 50,
      'max_connections' => 100,
      'wait_timeout' => 256,
      'max_connect_errors' => 10,
      'max_allowed_packet' => '16M',
      'max_heap_table_size' => '512M',
      'read_buffer_size' => '64M',
      'read_rnd_buffer_size' => '64M',
      'sort_buffer_size' => '64M',
      'join_buffer_size' => '64M',
    },
  }
  class { 'mysql::server':
    package_name            => 'mariadb-server',
    service_name            => 'mysqld',
    create_root_user        => true,
    root_password           => '$trongBad#1',
    remove_default_accounts => true,
    restart                 => true,
    reload_on_config_change => true,
    override_options        => $override_options,
  }
  class { 'zabbix::database':
    database_type => 'mysql',
    zabbix_server => 'monitor.preda.ca',
    zabbix_web    => 'monitor.preda.ca',
  }
}
