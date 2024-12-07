# Class: role::webserver
class role::webserver {
  include profile::base
  include profile::puppet_agent
  include profile::puppetboard
}
