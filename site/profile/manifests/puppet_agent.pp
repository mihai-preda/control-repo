# profile puppet agent
# class puppet agent
# @param puppet_server - the puppt master to point the agent to
# @param run_interval - the time interval at which the puppet agent should run
# @param environment - the code environment
# @param agent_version - the agent version to be installed
class profile::puppet_agent (
  String $puppet_server = 'puppet.preda.ca',
  String $run_interval  = '1h',
  String $environment   = 'production',
  String $agent_version = 'latest',
) {
  class { 'puppet_agent':
    package_version => $agent_version,
    collection      => 'puppet8',
    manage_repo     => true,
    config          => [
      {
        section => 'main',
        setting => 'server',
        value   => $puppet_server,
      },
      {
        section => 'main',
        setting => 'runinterval',
        value   => $run_interval,
      },

    ],
  }
}
