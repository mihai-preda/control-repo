# resolver profile
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
