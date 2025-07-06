# app1 role
class role::app1 {
  include profile::tomcat
  contain openssl::certificate::x509
  include role::default
}
