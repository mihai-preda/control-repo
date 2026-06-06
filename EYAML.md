# eyaml config

## The Puppet server runs as 'puppet', so it needs to own (or at least read) the key

chown puppet:puppet /etc/puppetlabs/puppet/eyaml/keys/private_key.pkcs7.pem
chown puppet:puppet /etc/puppetlabs/puppet/eyaml/keys/public_key.pkcs7.pem

## Private key should be readable only by the puppet user

chmod 0400 /etc/puppetlabs/puppet/eyaml/keys/private_key.pkcs7.pem

## Public key can be a bit more open

chmod 0644 /etc/puppetlabs/puppet/eyaml/keys/public_key.pkcs7.pem

## final steps

create a symlink of eyaml in /etc/puppetlabs/puppet/eyaml
when encrypting ssh keys use the following pattern: eyaml encrypt -s 'ssh-ed25519 AAAANa... comment'
if comment is missing, puppet will not be able to parse the key when decrypting
