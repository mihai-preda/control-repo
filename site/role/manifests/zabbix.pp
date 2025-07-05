# role zabbix_server
class role::zabbix {
  include profile::zabbix
  include profile::resolver
  include role::default
}
