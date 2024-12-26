# role mysql
class role::zabix_db {
  include profile::base
  include profile::zabbix_db
}
