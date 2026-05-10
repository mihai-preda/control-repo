# role db
class role::puppetdb {
  include role::default
  include profile::puppetdb
  include profile::zabbixdb
  include profile::resolver
  include firewalld
}
