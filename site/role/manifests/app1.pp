# app1 role
class role::app1 {
  contain openssl::certificates
  include profile::tomcat
  include role::default
  include profile::ssc
}
