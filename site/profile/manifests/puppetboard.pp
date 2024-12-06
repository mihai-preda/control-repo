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
  }

# Access Puppetboard through pboard.example.com
  class { 'puppetboard::apache::vhost':
    vhost_name => 'web.preda.ca',
    port       => 80,
  }
}
