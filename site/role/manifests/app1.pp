# app1 role
class role::app1 {
  include accounts
  include profile::tomcat
  include firewalld
  include profile::packages
  include profile::base
}
