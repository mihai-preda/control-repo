# openssl
class { 'openssl':
  package_ensure         => latest,
  ca_certificates_ensure => latest,
}
openssl::certificate::x509 { 'hostcert':
  commonname => $facts['networking']['fqdn'],
}
