# role webserver
class role::webserver {
  include profile::base
  include profile::puppet_agent
  include profile::puppetboard
  include profile::zabbix_agent
  include profile::epel
}
