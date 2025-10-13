# Tomcat manifests file
class profile::tomcat {
  tomcat::install { '/opt/tomcat':
    source_url => 'https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.11/bin/apache-tomcat-11.0.11.tar.gz',
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
  tomcat::war { 'sample.war':
    catalina_base => '/opt/tomcat/first',
    war_source    => '/opt/tomcat/webapps/docs/appdev/sample/sample.war',
  }
}
