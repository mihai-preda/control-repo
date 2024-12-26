# role mysql
class role::zabbixdb {
  include profile::base
  include profile::zabbixdb
}
