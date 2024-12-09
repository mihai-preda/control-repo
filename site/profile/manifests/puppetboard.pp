# Class: profile::puppetboard
class profile::puppetboard {
  # Configure Apache on this server
  class { 'apache':
    default_vhost => false,
  }

# Configure Puppetboard
  class { 'puppetboard':
    python_version    => '3.9',
    secret_key        => 'guardians0-=1',
    manage_virtualenv => true,
    puppetdb_host     => 'db.preda.ca',
    puppetdb_port     => 8081,
  }

# Access Puppetboard through pboard.example.com
  class { 'puppetboard::apache::vhost':
    vhost_name     => 'web.preda.ca',
    port           => 443,
    ssl            => true,
    ssl_cert       => '/etc/pki/tls/certs/cert.pem',
    ssl_key        => '/etc/pki/tls/private/privatekey.pem',
    ssl_cert_chain => '/etc/pki/tls/certs/chain.pem',
  }
}
