# app1 role
class role::app1 {
  include accouts
  include profile::ssc
  include profile::tomcat
  include firewalld
  include profile::packages
  include profile::base
}
