# Tomcat manifests file
# @param source_url - the URL to download the Tomcat package from
class profile::tomcat (
  String $source_url,
) {
  tomcat::install { '/opt/tomcat':
    source_url => $source_url,
  }
  tomcat::instance { 'default':
    catalina_home => '/opt/tomcat',
  }
  package { 'java-17-openjdk-headless':
    ensure => 'present',
  }
  tomcat::config::server::connector { 'default':
    catalina_base         => '/opt/tomcat',
    port                  => '8081',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => '8443',
    },
  }
  firewall { '101 allow http and https access':
    dport => [8081, 8443],
    proto => 'tcp',
    jump  => 'accept',
  }
}
