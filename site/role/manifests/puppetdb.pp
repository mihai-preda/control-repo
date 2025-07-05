# role db
class role::puppetdb {
  include profile::puppet_agent
  include profile::puppetdb
  include profile::zabbixdb
  include profile::resolver
}
