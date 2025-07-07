# control-repo
To be used after the initial config with Puppet Bolt.
## Puppetdb
PuppetDB will accept any valid certificates from PuppetBoard.
Even copies of the puppet client certificates and keys (copied to /etc/pki/tls/$), as long as they're valid,
and the group is set to Apache for the cert and key. The CA cert can keep root ownership and group.
Cert, CA cert, and private key must have -rw-r--r-- ownership for PB to load.
DNS is highly recommended. It makes things easier to connect like nodes to puppet master
or pp board to ppdb.
## Zabbix
Use Postgresql instead of MySQL. It's smoother.
## Openssl
Use the puppet class profile
The hiera example doesn't work. No matter what!