# role webserver
class role::webserver {
  include profile::puppetboard
  include profile::resolver
  include accounts
  include firewalld
  include profile::base
}
