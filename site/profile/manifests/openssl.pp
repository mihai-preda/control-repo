# Generate Sel-Signed Certificates
class profile::openssl {
  class { 'openssl':
    package_ensure         => latest,
    ca_certificates_ensure => latest,
  }
  $fqdn = $facts['networking']['fqdn']
  class { 'openssl::configs':
    country   => 'CA',
    locality  => 'Burnaby',
    state     => 'British Columbia',
    conffiles => { '/etc/pki/tls/misc/openssl.conf' => { ensure => 'present',
        commonname                                              => $fqdn,
      organization                                              => 'Preda.ca' },
    },
  }
  openssl::certificate::x509 { $fqdn:
    commonname => $facts['networking']['fqdn'],
  }
  $ssl_dir = '/etc/pki/tls'
  openssl::export::pkcs12 { $fqdn:
    ensure   => 'present',
    basedir  => "${ssl_dir}/private",
    pkey     => "${ssl_dir}/certs/${fqdn}.key",
    cert     => "${ssl_dir}/certs/${fqdn}",
    in_pass  => '34polla0_5710]fer',
    out_pass => '1k0eop3l0-2jd]3hh7',
  }
}
