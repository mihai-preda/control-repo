# role mysql
class role::zabixdb {
  include profile::base
  include profile::zabbixdb
}
