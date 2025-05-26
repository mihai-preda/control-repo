# role default
class role::default {
  include profile::base
  include epel
  include profile::zabbix_agent
}
