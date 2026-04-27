# site
node 'db.preda.ca' { include role::puppetdb }
node default { include role::default }
node 'puppet.preda.ca' { include role::puppetserver }
node 'web.preda.ca' { include role::webserver }
node 'monit.preda.ca' { include role::zabbix }
node 'app-srv1.preda.ca' { include role::app1 }
node 'mj08fld2.preda.ca' { include role::sp1 }
