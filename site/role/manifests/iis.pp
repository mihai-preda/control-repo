# IIS role
class role::iis {
  include profile::iis
  include zabbix_agent::windows
}
