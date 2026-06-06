# role db
class role::puppetdb {
  include accounts
  include profile::puppetdb
  include profile::zabbixdb
  include profile::resolver
  include profile::base
}
