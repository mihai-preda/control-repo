# Self-signed TSL certificates
class profile::tls {
  $cert_dir    = '/etc/pki/tls/ssc'
  $cert_file   = "${cert_dir}/server.crt"
  $key_file    = "${cert_dir}/server.key"
  $chain_file  = "${cert_dir}/chain.crt"
  $fullchain_file = "${cert_dir}/fullchain.crt"

  file { $cert_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  exec { 'generate_self_signed_cert':
    command => '/usr/bin/openssl ecparam -genkey -name prime256v1 -days 365 ' +
    "-keyout ${key_file} -out ${cert_file} " +
    "-subj '/CN=${facts['networking']['fqdn']}'",
    creates => $cert_file,
    require => File[$cert_dir],
    path    => ['/usr/bin', '/bin'],
  }

  file { [$key_file, $cert_file]:
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  # Assuming the chain file is shipped with your Puppet module or available on the Puppet server
  file { $chain_file:
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/ssl/chain.crt',  # Adjust to your module/files path
  }

  # Optional: Create fullchain (cert + chain)
  exec { 'combine_cert_and_chain':
    command => "/bin/cat ${cert_file} ${chain_file} > ${fullchain_file}",
    creates => $fullchain_file,
    require => [Exec['generate_self_signed_cert'], File[$chain_file]],
    path    => ['/usr/bin', '/bin'],
  }

  file { $fullchain_file:
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
