# role db
class role::puppetdb {
  include profile::base
  include profile::puppet_agent
  include profile::puppetdb
  include profile::zabbixdb
  include profile::zabbix_agent
  include epel
  include profile::resolver
}
