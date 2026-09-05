# Tomcat manifests file
#
# Tomcat is installed from the distro AppStream repo rather than a tarball.
# EL9 ships tomcat 9.0.x and EL10 ships tomcat 10.1.x under the same package
# name and with an identical on-disk layout, so this profile is portable
# across both majors. The RPM requires "(java-headless or java-25-headless)"
# and ships its own tomcat.service unit, so neither a JDK package nor a
# systemd unit is declared here.
#
# The 8443 connector serves a self-signed cert on purpose: this backend is
# meant to sit behind an httpd front-end that terminates real (public) TLS, so
# the proxy->Tomcat hop stays encrypted (a common Cybersecurity mandate). The
# cert is a plain PEM pair generated with the openssl CLI, so no openssl Puppet
# module is needed.
#
# @param package_name the AppStream package to install. EL10 also ships a
#   parallel-installable 'tomcat9' if the 9.0.x branch is wanted there.
# @param test_app deploy the /test smoke-test webapp (a single JSP reporting
#   container, JVM and connector). Off by default; this is a lab aid, not
#   something to ship on a real app server.
class profile::tomcat (
  String[1] $package_name = 'tomcat',
  Boolean   $test_app     = false,
) {
  # CATALINA_HOME as laid out by the RPM. conf/ is a symlink to /etc/tomcat,
  # so the connector resources below edit /etc/tomcat/server.xml through it.
  $catalina_home = '/usr/share/tomcat'
  $cert = '/etc/tomcat/tomcat-selfsigned.crt'
  $key  = '/etc/tomcat/tomcat-selfsigned.key'
  $fqdn = $facts['networking']['fqdn']

  tomcat::install { $catalina_home:
    install_from_source => false,
    package_name        => $package_name,
  }

  # catalina_base is left to default to catalina_home, which keeps
  # tomcat::instance away from the RPM's directory layout - it only creates and
  # populates directories when a separate base is requested. The packaged
  # tomcat.service unit runs the service, so the module must not declare its
  # own exec-based service for this single instance.
  tomcat::instance { 'default':
    catalina_home  => $catalina_home,
    manage_service => false,
  }

  # Plain HTTP connector; 8443 is its redirect target for secured resources.
  tomcat::config::server::connector { 'default':
    catalina_base         => $catalina_home,
    port                  => '8081',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'redirectPort' => '8443',
    },
  }

  # Self-signed PEM cert + key for the TLS connector. openssl ships with the
  # base OS, so this needs no openssl Puppet module. Idempotent via `creates`.
  # The tomcat package must land first: it creates /etc/tomcat and the tomcat
  # user and group the files below are owned by.
  exec { 'tomcat-selfsigned-cert':
    command  => "/usr/bin/openssl req -x509 -newkey rsa:2048 -nodes -keyout ${key} -out ${cert} -days 3650 -subj '/CN=${fqdn}/OU=Lab/O=Preda/L=Delta/ST=British Columbia/C=CA' -addext 'subjectAltName=DNS:${fqdn}'",
    creates  => $cert,
    provider => 'shell',
    path     => ['/usr/bin', '/bin'],
    require  => Tomcat::Install[$catalina_home],
  }

  file { $key:
    ensure  => file,
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0600',
    require => Exec['tomcat-selfsigned-cert'],
  }

  file { $cert:
    ensure  => file,
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0644',
    require => Exec['tomcat-selfsigned-cert'],
  }

  # TLS connector. The cert_*_file params make the module emit a nested
  # SSLHostConfig/Certificate; attributes_to_remove strips the deprecated
  # connector-level keystore* attributes.
  tomcat::config::server::connector { 'https':
    catalina_base         => $catalina_home,
    port                  => '8443',
    protocol              => 'HTTP/1.1',
    additional_attributes => {
      'SSLEnabled' => 'true',
      'scheme'     => 'https',
      'secure'     => 'true',
    },
    attributes_to_remove  => ['keystoreFile', 'keystorePass', 'keystoreType', 'clientAuth', 'sslProtocol'],
    cert_key_file         => $key,
    cert_file             => $cert,
    cert_chain_file       => $cert,
    cert_type             => 'RSA',
  }

  # The unit comes from the RPM, so this only enables and starts it.
  service { 'tomcat':
    ensure    => running,
    enable    => true,
    require   => Tomcat::Install[$catalina_home],
    subscribe => [
      Tomcat::Config::Server::Connector['default'],
      Tomcat::Config::Server::Connector['https'],
      File[$key],
      File[$cert],
    ],
  }

  # Smoke-test webapp: one JSP served from an exploded directory under the
  # RPM's webapps root. Deliberately not the tomcat-webapps subpackage - that
  # drags in the examples app. Exercising a JSP rather than static HTML proves
  # Jasper and ecj compile at request time, not just that the connector answers.
  if $test_app {
    file { '/var/lib/tomcat/webapps/test':
      ensure  => directory,
      owner   => 'tomcat',
      group   => 'tomcat',
      mode    => '0755',
      require => Tomcat::Install[$catalina_home],
    }

    file { '/var/lib/tomcat/webapps/test/index.jsp':
      ensure  => file,
      owner   => 'tomcat',
      group   => 'tomcat',
      mode    => '0644',
      source  => 'puppet:///modules/profile/testapp/index.jsp',
      require => File['/var/lib/tomcat/webapps/test'],
    }
  }

  # This node runs firewalld, so open the Tomcat ports with firewalld_port
  # rather than the iptables `firewall` type, which has no persistence here.
  firewalld_port { 'tomcat-http':
    ensure   => present,
    zone     => 'public',
    port     => 8081,
    protocol => 'tcp',
  }

  firewalld_port { 'tomcat-https':
    ensure   => present,
    zone     => 'public',
    port     => 8443,
    protocol => 'tcp',
  }
}
