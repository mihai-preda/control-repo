# role server physical 1
class role::sp1 {
  include profile::resolver
  include theforeman
  include role::default
}
