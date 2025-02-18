# IIS role
class role::iis {
  include profile::iis
  include profile::zabbix_agent
  include profile::zba_win
}
