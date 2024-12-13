# control-repo
To be used after the initial config with Puppet Bolt.
## Puppetdb
PuppetDB will accept any valid certificates from PuppetBoard.
Even copies of the puppet client certificates and keys, as long as they're valid,
and the group is set to Apache for the cert and key. The CA cert can keep root ownership and group.
DNS is highly recommended. It makes things easier to connect like nodes to puppet master
or pp board to ppdb.