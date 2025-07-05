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
  class { 'openssl':
    package_ensure         => latest,
    ca_certificates_ensure => latest,
  }
}
