# Class: role::webserver
class role::webserver {
  # resources
  include profile::base
  include profile::puppet_agent
}
