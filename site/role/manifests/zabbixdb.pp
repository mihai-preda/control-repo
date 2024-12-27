# role mysql
class role::zabbixdb {
  include profile::base
  include profile::zabbixdb
  include profile::zabbix_agent
}
