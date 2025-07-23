# role server physical 1
class role::sp1 {
  include profile::resolver
  include puppet #this is the foreman puppet module. fails with 'extlib::ip_to_cron'
  include role::default
}
