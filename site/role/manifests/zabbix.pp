# role zabbix_server
class role::zabbix {
  include profile::base
  include profile::zabbix
  include profile::zabbix_agent
  include epel
  include profile::resolver
}
