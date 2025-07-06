# certificates
openssl::certificate::x509 { 'app1-srv':
  ensure       => present,
  country      => 'CA',
  organization => 'preda.ca',
  commonname   => $fqdn,
}
