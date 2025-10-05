# modules/profile/manifests/cert_chain.pp
# @param ca_name - name of the local cerificate authority
# @param ca_dir - directory where to store the CA cert
# @param ca_key_password - password to encrypt the CA key
# @param ca_days - days the CA certificate will be valid for
# @param node_days - the number of days the node certificate will be valid for
# @param req_ext - additional subject alternative names
class profile::cert_chain (
  String $ca_name         = 'local_ca',
  String $ca_dir          = '/etc/ssl/local_ca',
  String $ca_key_password = undef,  # Use Hiera eyaml or secrets backend in production
  Integer $ca_days        = 3650,
  Integer $node_days      = 365,
  Array[String] $req_ext = [],
) {
  $fqdn = $facts['networking']['fqdn']
  $node_key_path  = "/etc/ssl/private/${fqdn}.key"
  $node_cert_path = "/etc/ssl/certs/${fqdn}.crt"
  $chain_path     = "/etc/ssl/certs/${fqdn}_fullchain.crt"

  # CA private key
  ssl_key { "${ca_name}_key":
    ensure         => present,
    password       => $ca_key_password,
    authentication => 'ec',
    path           => "${ca_dir}/${ca_name}.key",
  }

  # Node private key
  ssl_key { "node_key_${fqdn}":
    ensure         => present,
    authentication => 'ec',
  }

  # CA certificate
  openssl::certificate::x509 { "${ca_name}_cert":
    ensure               => present,
    private_key_password => $ca_key_password,
    days                 => $ca_days,
    key_type             => 'ec',
    allow_self_signed    => true,
    ca                   => true,
    commonname           => $ca_name,
  }

  # Node certificate signed by CA
  #$san_list = ["DNS:${fqdn}"] + $req_ext

  openssl::certificate::x509 { "node_cert_${fqdn}":
    ensure          => present,
    days            => $node_days,
    key_type        => 'ec',
    ca              => "${ca_dir}/${ca_name}.crt",
    ca_key          => "${ca_dir}/${ca_name}.key",
    ca_key_password => $ca_key_password,
    commonname      => $fqdn,
  }

  # Optional: concatenate full chain
  exec { "concat_cert_chain_${fqdn}":
    command => "cat ${node_cert_path} ${ca_dir}/${ca_name}.crt > ${chain_path}",
    creates => $chain_path,
    require => Openssl::Certificate::X509["node_cert_${fqdn}"],
  }
}
