# app1 role
class role::app1 {
  include profile::tomcat
  #include profile::openssl
  include role::default
}
