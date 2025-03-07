# site
node 'db.preda.ca' { include role::puppetdb }
node default { include role::default }
node 'puppet.preda.ca' { include role::puppetserver }
node 'web.preda.ca' { include role::webserver }
node 'monitor.preda.ca' { include role::zabbix }
node 'zdb.preda.ca' { include role::zabbixdb }
node 'win-tan06jp8l69.preda.ca' { include role::iis }
node 'phys-srv-01.preda.ca' { include role::sp1 }
