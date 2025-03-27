# puppet server profile
class profile::puppetserver {
  package { 'puppetserver':
    ensure => 'installed',
  }
  file { 'sysconfig-puppetserver':
    ensure  => 'file',
    path    => '/etc/sysconfig/puppetserver',
    source  => '/puppet_course/files/sysconfig-puppetserver',
    require => Package['puppetserver'],
  }
  service { 'puppetserver':
    ensure  => true,
    enable  => true,
    require => [Package['puppetserver'], File['sysconfig-puppetserver']],
  }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config':
    enable_reports          => true,
    manage_report_processor => true,
    puppetdb_server         => 'db.preda.ca',
    puppetdb_port           => 8081,
    manage_routes           => true,
  }
  class { 'hiera':
    hiera5_defaults      => { 'datadir' => 'data', 'data_hash' => 'yaml_data' },
    hierarchy            => [
      { 'name' => 'Virtual yaml', 'path'  => 'virtual/%{virtual}.yaml' },
      { 'name' => 'Nodes yaml', 'paths' => ['nodes/%{trusted.certname}.yaml', 'nodes/%{osfamily}.yaml'] },
      { 'name' => 'Default yaml file', 'path' => 'common.yaml' },
    ],
    eyaml                => true,
    eyaml_gpg            => false,
    eyaml_gpg_recipients => 'mihai@preda.ca',
  }
}
