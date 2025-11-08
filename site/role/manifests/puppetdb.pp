# role db
class role::puppetdb {
  include profile::default
  include profile::puppet_agent
  include profile::puppetdb
  include profile::zabbixdb
  include profile::resolver
  include epel
}
