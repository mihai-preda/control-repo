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
  $keystore_path = '/etc/pki/tls/certs'
  $fqdn = $facts['networking']['fqdn']
  $ssl_dir = '/etc/pki/tls'
  $keystore_source = "${ssl_dir}/private/${fqdn}.p12"
  file { $keystore_path:
    ensure         => file,
    source         => $keystore_source,
    #owner          => $keystore_user,
    mode           => '0400',
    checksum       => 'md5',
    checksum_value => $keystore_checksum,
  }

  -> tomcat::config::server::connector { "${tomcat_instance}-https":
    catalina_base         => $catalina_base,
    port                  => $https_port,
    protocol              => $http_version,
    purge_connectors      => true,
    cert_key_file         => "${ssl_dir}/certs/${fqdn}.key",
    cert_file             => "${ssl_dir}/certs/${fqdn}.crt",
    #cert_chain_file       => "${ssl_dir}/certs/",
    cert_type             => 'RSA',
    additional_attributes => {
      'SSLEnabled'          => bool2str($https_enabled),
      'maxThreads'          => $https_connector_max_threads,
      'scheme'              => $https_connector_scheme,
      'secure'              => bool2str($https_connector_secure),
      'clientAuth'          => bool2str($https_connector_client_auth),
      'sslProtocol'         => $https_connector_ssl_protocol,
      'sslEnabledProtocols' => join($https_connector_ssl_protocols_enabled, ','),
      'ciphers'             => join($ciphers_enabled, ','),

      'keystorePass'        => $keystore_pass.unwrap,
      'keystoreFile'        => $keystore_path,
    },
  }
}
