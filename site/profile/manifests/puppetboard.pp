# Class: profile::puppetboard
class profile::puppetboard {
  # Configure Apache on this server
  class { 'apache':
    default_vhost => false,
  }

# Configure Puppetboard
# SSL certificates are required and puppetboard and
# puppetdb run on separate hosts. Copied puppet certs from
# /etc/puppetlabs/puppet/ssl to /etc/pki/tls
# and pointed this config to them
  $ssl_dir = '/etc/pki/tls'
  $puppetboard_certname = 'web.preda.ca'
  class { 'puppetboard':
    python_version      => '3.9',
    secret_key          => 'guardians0-=1',
    manage_virtualenv   => true,
    groups              => 'apache',
    puppetdb_host       => 'db.preda.ca',
    puppetdb_port       => 8081,
    puppetdb_key        => "${ssl_dir}/private/${puppetboard_certname}.pem",
    puppetdb_ssl_verify => "${ssl_dir}/certs/ca.pem",
    puppetdb_cert       => "${ssl_dir}/certs/${puppetboard_certname}.pem",
  }

# Access Puppetboard through pboard.example.com
  class { 'puppetboard::apache::vhost':
    vhost_name => 'web.preda.ca',
    port       => 443,
    ssl        => true,
    ssl_cert   => '/etc/pki/tls/certs/cert.pem',
    ssl_key    => '/etc/pki/tls/private/privatekey.pem',
    ssl_chain  => '/etc/pki/tls/certs/chain.pem',
  }
}
