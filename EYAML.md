# eyaml config

## The Puppet server runs as 'puppet', so it needs to own (or at least read) the key

chown puppet:puppet /etc/puppetlabs/puppet/eyaml/keys/private_key.pkcs7.pem
chown puppet:puppet /etc/puppetlabs/puppet/eyaml/keys/public_key.pkcs7.pem

## Private key should be readable only by the puppet user

chmod 0400 /etc/puppetlabs/puppet/eyaml/keys/private_key.pkcs7.pem

## Public key can be a bit more open

chmod 0644 /etc/puppetlabs/puppet/eyaml/keys/public_key.pkcs7.pem
