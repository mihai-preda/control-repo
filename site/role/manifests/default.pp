# role default
class role::default {
  include accounts
  include profile::puppet_agent
  include profile::base
  include epel
  include profile::zabbix_agent
  include profile::hiera_test
}
