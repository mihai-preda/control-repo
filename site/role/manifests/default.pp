# role default
class role::default {
  include accounts
  include profile::openvox_agent
  include profile::base
  include epel
  include profile::zabbix_agent
  include profile::hiera_test
  # DO NOT include FIREWALLD here
}
