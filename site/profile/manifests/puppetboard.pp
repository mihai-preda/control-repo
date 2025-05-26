# profile puppetboard
class profile::puppetboard {
  # Configure Apache on this server
  class { 'apache':
    default_vhost => false,
  }
  class { 'apache::mod::status':
    requires => 'ip 127.0.0.1 ::1 10.21.2.0/24',
  }

# Configure Puppetboard
# SSL certificates are required when puppetboard and
# puppetdb run on separate hosts. SEE ->README.md!!!
  $ssl_dir = '/etc/pki/tls'
  $puppetboard_certname = 'web.preda.ca'
  class { 'puppetboard':
    python_version      => '3.9',
    secret_key          => 'guardians0-=1',
    manage_virtualenv   => true,
    puppetdb_host       => 'db.preda.ca',
    puppetdb_port       => 8081,
    puppetdb_key        => "${ssl_dir}/private/${puppetboard_certname}.pem",
    puppetdb_ssl_verify => "${ssl_dir}/certs/ca.pem",
    puppetdb_cert       => "${ssl_dir}/certs/${puppetboard_certname}.pem",
  }

# Access Puppetboard through pboard.example.com
  class { 'puppetboard::apache::vhost':
    vhost_name => 'web.preda.ca',
    port       => [80, 443],
    ssl        => true,
    ssl_cert   => '/etc/pki/tls/certs/cert.pem',
    ssl_key    => '/etc/pki/tls/private/privatekey.pem',
    ssl_chain  => '/etc/pki/tls/certs/chain.pem',
  }
}
