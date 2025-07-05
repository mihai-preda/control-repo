# role puppet server
class role::puppetserver {
  include profile::puppetserver
  include profile::resolver
  include profile::puppet_agent
  include role::default
}
