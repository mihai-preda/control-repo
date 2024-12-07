# Class: puppetdb
class profile::puppetdb {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    postgresql_ssl_on       => true,
    database_host           => 'db.preda.ca',
    database_listen_address => '*',
    database_password       => 'ctm3muf7tze!PYN@pvj',
  }
  exec { '/opt/puppetlabs/bin/puppetdb ssl-setup -f': }
}
