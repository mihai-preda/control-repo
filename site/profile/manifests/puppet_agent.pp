# profile puppet agent
class profile::puppet_agent {
  class { 'puppet_agent':
    package_version => '8.10.0',
    collection      => 'puppet8',
    config          => [{ section => main, setting => runinterval, value => '2h' }],
  }
}
