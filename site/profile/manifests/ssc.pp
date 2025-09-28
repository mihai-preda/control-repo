# self-signed certificate
class profile::ssc {
  $fqdn = $facts['networking']['fqdn']
  $ssl_dir = '/etc/pki/tls'
  class { 'openssl':
    package_ensure         => latest,
    ca_certificates_ensure => latest,
  }
  openssl::certificate::x509 { "%['networking']['fqdn']":
    commonname => $fqdn,
    country    => 'CA',
    state      => 'British Columbia',
    locality   => 'Delta',
    days       => 365,
  }
  openssl::export::pkcs12 { "${ssl_dir}/private/${fqdn}.p12":
    ensure    => 'present',
    basedir   => '/etc/pki/tls/',
    pkey      => "${ssl_dir}/private/${fqdn}.key",
    cert      => "${ssl_dir}/certs/${fqdn}.pem",
    out_pass  => '1k0eop3l0-2jd]3hh7',
    dynamic   => true,
    resources => File["${ssl_dir}/private/${fqdn}.key","${ssl_dir}/certs/${fqdn}.crt"],
  }
}
