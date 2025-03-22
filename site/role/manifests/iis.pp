# IIS role
class role::iis {
  include profile::iis
  include profile::zabbix_windows
}
