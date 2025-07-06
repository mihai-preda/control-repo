# role server physical 1
class role::sp1 {
  include profile::resolver
  include puppet
  include role::default
}
