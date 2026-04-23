# role webserver
class role::webserver {
  include profile::puppetboard
  include profile::resolver
  include role::default
  include firewalld
}
