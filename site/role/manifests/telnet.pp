# Telnet role
class role::telnet {
  include profile::telnet
  include profile::puppet_agent
}
