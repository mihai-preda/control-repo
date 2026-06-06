# role zabbix_server
class role::zabbix {
  include profile::zabbix
  include profile::resolver
  include accounts
  include firewalld
  include profile::base
  include epel
  include profile::zabbix_agent
}
