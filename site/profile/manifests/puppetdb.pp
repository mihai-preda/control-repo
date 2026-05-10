# profile puppetdb
class profile::puppetdb (
  String $database_password,
) {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    postgresql_ssl_on       => false,
    database_host           => 'db.preda.ca',
    database_listen_address => '0.0.0.0',
    database_password       => $database_password,
    node_ttl                => '0s',
    node_purge_ttl          => '0s',
  }
  exec { 'puppetdb ssl-setup':
    command => '/opt/puppetlabs/bin/puppetdb ssl-setup',
    unless  => '/usr/bin/test -f /etc/puppetlabs/puppetdb/ssl/ca.pem',
  }
  firewalld_port { 'puppetdb-http':
    ensure   => present,
    zone     => 'public',
    port     => 8080,
    protocol => 'tcp',
  }
  firewalld_port { 'puppetdb-https':
    ensure   => present,
    zone     => 'public',
    port     => 8081,
    protocol => 'tcp',
  }
  firewalld_port { 'zabbix-agent':
    ensure   => present,
    zone     => 'public',
    port     => 10050,
    protocol => 'tcp',
  }
  firewalld_port { 'zabbix-agent-active':
    ensure   => present,
    zone     => 'public',
    port     => 10051,
    protocol => 'tcp',
  }
}
