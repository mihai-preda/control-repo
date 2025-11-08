# resolver profile
# @param nameserver1 = local dns server
# @param nameserver2 = public dns server, usually quad9 or cloudflare's quad 1
# @param domain = local domain name
# @param search = domain to search
class profile::resolver (
  String $nameserver1 = '10.21.2.254',
  String $nameserver2 = '9.9.9.9',
  String $domain      = 'preda.ca',
  String $search      = 'preda.ca',
) {
  $str = "search ${search}
domain ${domain}
nameserver ${nameserver1}
nameserver ${nameserver2}
"

  file { '/etc/resolv.conf':
    ensure  => file,
    content => $str,
  }
}
