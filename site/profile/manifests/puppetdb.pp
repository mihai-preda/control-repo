# profile puppetdb
class profile::puppetdb {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    postgresql_ssl_on       => true,
    database_host           => 'db.preda.ca',
    database_listen_address => '0.0.0.0',
    database_password       => 'ctm3muf7tze!PYN@pvj',
    node_ttl                => '0s',
    node_purge_ttl          => '0s',
  }
  exec { '/opt/puppetlabs/bin/puppetdb ssl-setup -f': }
  firewall { '100 allow http and https access':
    dport => [8081, 8080],
    proto => 'tcp',
    jump  => 'accept',
  }
}
