# role puppet server
class role::puppetserver {
  include profile::puppetserver
  include profile::resolver
  include accounts
  include firewalld
}
