# certificates profile
class profile::certificates {
  $ssl_dir = '/etc/pki/tls'
  $ssl_files = '/puppet_course/files'
  file { 'certificate':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    path   => "${ssl_dir}/certs/cert.pem",
    source => "${ssl_files}/${facts['networking']['hostname']}-cert.pem",
  }
  file { 'chain':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    path   => "${ssl_dir}/certs/chain.pem" ,
    source => "${ssl_files}/${facts['networking']['hostname']}-chain.pem",
  }
  file { 'privatekey':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    path   => "${ssl_dir}/private/privatekey.pem",
    source => "${ssl_files}/${facts['networking']['hostname']}-privatekey.pem",
  }
}
