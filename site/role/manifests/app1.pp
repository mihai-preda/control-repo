# app1 role
class role::app1 {
  include profile::tomcat
  include openssl
  include role::default
}
