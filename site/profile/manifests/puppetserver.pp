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
  # comment the class below until the two servers are up
  class { 'puppetdb::master::config':
    enable_reports          => true,
    manage_report_processor => true,
    puppetdb_server         => 'db.preda.ca',
    puppetdb_port           => 8081,
    manage_routes           => true,
  }
}
