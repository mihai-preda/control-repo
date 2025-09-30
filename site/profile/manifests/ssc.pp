# self-signed certificate
# private key is created in /etc/pki/tls/certs
class profile::ssc {
  class { 'openssl':
    package_ensure         => latest,
    ca_certificates_ensure => latest,
  }
  openssl::certificate::x509 { $facts['networking']['fqdn']:
    commonname => $facts['networking']['fqdn'],
    country    => 'CA',
    state      => 'British Columbia',
    locality   => 'Delta',
    days       => 365,
    ca         => '/etc/pki/tls/certs/ca.pem',
  }
  $fqdn = $facts['networking']['fqdn']
  $ssl_dir = '/etc/pki/tls'
  openssl::export::pkcs12 { $fqdn:
    ensure    => 'present',
    basedir   => "${ssl_dir}/certs/",
    pkey      => "${ssl_dir}/certs/${fqdn}.key",
    cert      => "${ssl_dir}/certs/${fqdn}.crt",
    out_pass  => '1k0eop3l0-2jd]3hh7',
    dynamic   => true,
    resources => File["${ssl_dir}/certs/${fqdn}.key","${ssl_dir}/certs/${fqdn}.crt"],
  }
}
