# role db
class role::puppetdb {
  include profile::puppet_agent
  include profile::puppetdb
  include profile::zabbixdb
  include profile::resolver
  include accounts
  include profile::zabbix_agent
}
