# resolv_conf.pp
define resolve ($nameserver1, $nameserver2, $domain, $search) {
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

# Example of how to call the defined type
resolve { 'set_resolver':
  nameserver1 => '10.21.2.254',
  nameserver2 => '8.8.4.4',
  domain      => 'preda.ca',
  search      => 'preda.ca',
}
