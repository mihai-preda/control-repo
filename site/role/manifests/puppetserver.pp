# role puppet server
class role::puppetserver {
  include profile::puppetserver
  include profile::resolver
  include accounts
  include firewalld
  include profile::packages
  include profile::base
  include profile::zabbix_agent
}
