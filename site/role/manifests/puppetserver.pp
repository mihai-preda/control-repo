# role puppet server
class role::puppetserver {
  include profile::base
  include profile::puppetserver
  #include profile::zabbix_agent
  #include epel
  include profile::resolver
  include accounts
}
