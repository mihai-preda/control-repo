# role puppet_agent
class role::puppet_agent {
  include accounts
  include profile::puppet_agent
  include profile::base
  include epel
  include profile::zabbix_agent
}
