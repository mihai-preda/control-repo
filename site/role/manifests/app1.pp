# app1 role
class role::app1 {
  include profile::tomcat
  contain openssl
  include role::default
}
