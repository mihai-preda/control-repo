# app1 role
class role::app1 {
  include openssl
  include profile::tomcat
  include role::default
}
