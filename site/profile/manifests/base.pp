# base profile
class profile::base {
  exec { 'set locale':
    command => '/bin/localectl set-locale LANG=en_GB',
  }
  package { 'htop':
    ensure => 'present',
  }
  user { 'mihai':
    ensure => 'present',
    groups => ['wheel'],
    shell  => '/bin/bash',
  }
  file { '/home/mihai':
    ensure => directory,
    owner  => 'mihai',
    group  => 'mihai',
  }
  file { '/home/mihai/.ssh':
    ensure => directory,
    owner  => mihai,
    group  => mihai,
    mode   => '0700',
  }
  ssh_authorized_key { 'mihai':
    ensure => present,
    user   => 'mihai',
    type   => 'ssh-ed25519',
    key    => 'ENC[PKCS7,MIIBuQYJKoZIhvcNAQcDoIIBqjCCAaYCAQAxggEhMIIBHQIBAD
  AFMAACAQEwDQYJKoZIhvcNAQEBBQAEggEAQUR9HPdlkUlTJdPAhvnGnKgaxf
  7lg0/lBs5VETtueBx25zxypZqOmOOofdvuACFPvG0HZNJFG/fLyuntKHWO6+
  ZRnU67kXimVOrEpggZwETPqP42Nq20z0mMM941K+DHQaWjhKAFybZgE6AujY
  BPLAz/3/ACckUIbquV3wUcsa20s7Tn7XH451a0kW9DQ2p1GY2ySPz+Q+VLio
  4BuZUJqdZR5Sfv9bWXYin07t5hghvGCmhEpb83OR0zTr90+MJmjph80ppBUk
  4BIfTRnBbqIsCZ5HBp8P96iVjMvjURELgw575JgHYvN8x362QPIK9/P+ZniF
  7ShEkgzf2+yXW1DjB8BgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBCf8FQiAI
  Enp7gx7QQVS6aKgFDZ0pEGp6EAHTOGZgU9LZpWTUBHI0CtwZ5rzN4gAb9ytW
  xvjmmRvW3DT7d+54HuyczrPZ8SDk7GNB0QvnGAYoZNVnn3R6QLrsD3LcbLdS
  CbrQ==]',
  }
  notify { 'hello from the puppet server':
  }
  firewall { '000 accept all icmp requests':
    proto => 'icmp',
    jump  => 'accept',
  }
}
