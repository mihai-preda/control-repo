# Tomcat manifests file
class profile::tomcat {
  tomcat::install { '/opt/tomcat':
    source_url => 'https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.9/bin/apache-tomcat-11.0.9.tar.gz',
  }
  tomcat::instance { 'default':
    catalina_home => '/opt/tomcat',
  }
  package { 'java-17-openjdk-headless':
    ensure => 'present',
  }
  $fqdn = $facts['networking']['fqdn']
  $ssl_dir = '/etc/pki/tls'
  $keystore_source = "${ssl_dir}/certs/${fqdn}.p12"
  $keystore_path = "${ssl_dir}/certs/${fqdn}.p12"
  $keystore_pass = '1k0eop3l0-2jd]3hh7'
  $keystore_user = 'tomcat'
  $https_enabled = true
  $https_connector_max_threads = 200
  $https_connector_scheme = 'https'
  $https_connector_secure = true
  $https_connector_client_auth = true
  #$https_connector_ssl_protocol = 'TLSv1.2'+'TLSv1.3'
  file { $keystore_path:
    ensure   => file,
    source   => $keystore_source,
    owner    => $keystore_user,
    mode     => '0400',
    checksum => 'md5',
  }

  -> tomcat::config::server::connector { 'default-https':
    purge_connectors      => true,
    port                  => '8443',
    cert_key_file         => "${ssl_dir}/certs/${fqdn}.key",
    cert_file             => "${ssl_dir}/certs/${fqdn}.crt",
    cert_chain_file       => "${ssl_dir}/certs/ca.crt",
    cert_type             => 'RSA',
    additional_attributes => {
      'SSLEnabled'   => bool2str($https_enabled),
      'maxThreads'   => $https_connector_max_threads,
      'scheme'       => $https_connector_scheme,
      'secure'       => bool2str($https_connector_secure),
      'clientAuth'   => bool2str($https_connector_client_auth),
      #'sslProtocol'  => $https_connector_ssl_protocol,
      #'sslEnabledProtocols' => join($https_connector_ssl_protocols_enabled, ','),
      #'ciphers'             => join($ciphers_enabled, ','),

      'keystorePass' => $keystore_pass.unwrap,
      'keystoreFile' => $keystore_path,
    },
  }
}
