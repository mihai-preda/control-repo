# puppet server profile
class profile::puppetserver {
  package { 'puppetserver':
    ensure => 'installed',
  }
  service { 'puppetserver':
    ensure  => true,
    enable  => true,
    require => Package['puppetserver'],
  }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config':
    enable_reports          => true,
    manage_report_processor => true,
    puppetdb_server         => 'db.preda.ca',
    puppetdb_port           => 8081,
    manage_routes           => true,
  }
  package { 'hiera-eyaml':
    ensure   => 'installed',
    provider => 'puppetserver_gem',
  }
  # Global layer hiera config
  class { 'hiera':
    hiera_version   => '5',
    hiera5_defaults => {
      'datadir'    => 'data',
      'lookup_key' => 'eyaml_lookup_key',
      'options'    => {
        'pkcs7_private_key' => '/etc/puppetlabs/puppet/eyaml/keys/private_key.pkcs7.pem',
        'pkcs7_public_key'  => '/etc/puppetlabs/puppet/eyaml/keys/public_key.pkcs7.pem',
      },
    },
    hierarchy       => [
      { 'name' => 'Nodes yaml', 'path' => 'nodes/%{trusted.certname}.yaml' },
      { 'name' => 'OsFamily yaml', 'path' => 'os/%{facts.os.family}.yaml' },
      { 'name' => 'Default yaml file', 'path' => 'common.yaml' },
    ],
  }
}
