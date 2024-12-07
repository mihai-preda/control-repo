# Class: puppetdb
class profile::puppetdb {
  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    postgresql_ssl_on       => true,
    database_host           => 'db.preda.ca',
    database_listen_address => '0.0.0.0',
  }
  exec { '/opt/puppetlabs/bin/puppetdb ssl-setup -f': }

  puppet_authorization::rule { 'puppetlabs puppetdb metrics':
    # Allow nodes to access the metrics service
    # for puppetdb, the metrics service is the only
    # service using the authentication service
    match_request_path    => '/metrics',
    match_request_type    => 'path',
    match_request_method  => [get, post],
    allow_unauthenticated => true,
    sort_order            => 500,
    path                  => '/etc/puppetlabs/puppetdb/conf.d/auth.conf',
  }
}
