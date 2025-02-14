# role puppet server
class role::puppetserver {
  include profile::base
  include profile::puppetserver
  include profile::zabbix_agent
  include profile::epel
}
