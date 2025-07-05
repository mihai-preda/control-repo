# role default
class role::default {
  include accounts
  include profile::base
  include epel
  include profile::zabbix_agent
}
