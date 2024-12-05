# Class: puppet server
#
class role::puppetserver {
  include profile::base
  include profile::puppetserver
  include profile::r10k
}
