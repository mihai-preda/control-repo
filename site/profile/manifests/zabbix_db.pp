# zabbix db server
class { 'mysql::server':
  root_password           => '$trongBad#1',
  remove_default_accounts => true,
  restart                 => true,
  override_options        => $override_options,
}
mysql_user { '[root@127.0.0.1]':
  ensure        => present,
  password_hash => mysql::password($mysql::server::root_password),
}
$override_options = {
  'mysqld' => {
    'port' => 3306,
    'socket' => '/tmp/mysql.sock',
    'back_log' => 50,
    'max_connections' => 100,
    'wait_timeout' => 256,
    'max_connect_errors' => 10,
    # 'max_allowed_packet' => '16M',
    # 'max_heap_table_size' => '512M',
    # 'read_buffer_size' => '64M',
    # 'read_rnd_buffer_size' => '64M',
    # 'sort_buffer_size' => '64M',
    # 'join_buffer_size' => '64M',
  },
  'client' => {
    'port' => 3306,
    'socket' => '/tmp/mysql.sock',
  },
}
mysql::db { 'zdb1':
  user     => 'zabbix',
  password => 'Burninator@1',
  host     => '172.16.10.%',
  grant    => ['ALL'],
}
class { 'zabbix::database':
  database_type => 'mysql',
  zabbix_server => 'monitor.preda.ca',
  zabbix_web    => 'monitor.preda.ca',
}
