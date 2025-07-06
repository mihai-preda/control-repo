# certificates
class { 'openssl':
  package_ensure         => latest,
  ca_certificates_ensure => latest,
}
openssl::certificate::x509 { 'app1-srv':
  ensure       => present,
  country      => 'CA',
  organization => 'preda.ca',
  commonname   => $fqdn,
}
