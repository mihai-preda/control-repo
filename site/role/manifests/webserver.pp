# role webserver
class role::webserver {
  include profile::puppet_agent
  include profile::puppetboard
  include profile::resolver
  include role::default
}
