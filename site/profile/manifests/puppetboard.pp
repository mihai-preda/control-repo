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
  file { "${ssl_dir}/private/${facts['networking']['fqdn']}.pem":
    ensure => file,
    mode   => '0644',
    group  => apache,
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
  }
  file { "${ssl_dir}/certs/${facts['networking']['fqdn']}.pem":
    ensure => file,
    mode   => '0644',
    group  => apache,
    source => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
  }
  file { "${ssl_dir}/certs/ca.pem":
    ensure => file,
    mode   => '0644',
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  }

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
    port       => 443,
    ssl        => true,
    ssl_cert   => "${ssl_dir}/certs/${facts['networking']['fqdn']}-cert.pem",
    ssl_key    => "${ssl_dir}/private/${facts['networking']['fqdn']}-key.pem",
    ssl_chain  => "${ssl_dir}/certs/${facts['networking']['fqdn']}-chain.pem",
  }
}
