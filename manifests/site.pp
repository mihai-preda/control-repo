# site
node 'db.preda.ca' { include role::db }
node default { include role::default }
node 'puppet.preda.ca' { include role::puppetserver }
node 'web.preda.ca' { include role::webserver }
node 'monitor.preda.ca' { include role::zabbix_server }
node 'zdb.preda.ca' { include role::zabbixdb }
