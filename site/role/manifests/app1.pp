# app1 role
class role::app1 {
  include accounts
  include epel
  include profile::tomcat
  include firewalld
  include profile::packages
  include profile::base
  include profile::zabbix_agent

  # EPEL must be configured before profile::base installs htop from it.
  Class['epel'] -> Class['profile::base']
}
