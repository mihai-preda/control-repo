# app1 role
class role::app1 {
  include role::default
  contain openssl::certificates
  include profile::ssc
  include profile::tomcat
}
