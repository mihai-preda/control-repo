# site
node 'db.preda.ca' { include role::puppetdb }
node default { include role::default }
node 'puppet.preda.ca' { include role::puppetserver }
node 'web.preda.ca' { include role::webserver }
node 'monitor.preda.ca' { include role::zabbix }
node 'zdb.preda.ca' { include role::zabbixdb }
node 'win-38njq8tg.preda.ca' { include role::iis }
node 'mini.preda.ca' { include role::sp1 }
