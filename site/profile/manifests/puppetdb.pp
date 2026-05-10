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
  firewall { '100 allow puppetdb':
    dport => [8080, 8081],
    proto => 'tcp',
    jump  => 'accept',
  }
  firewall { '101 allow zabbix agent':
    proto => 'tcp',
    dport => [10050, 10051],
    jump  => 'accept',
  }
}
