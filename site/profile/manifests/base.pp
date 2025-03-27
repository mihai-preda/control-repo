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
    key    => 'ENC[PKCS7,MIIBuQYJKoZIhvcNAQcDoIIBqjCCAaYCAQAxggEhMIIBHQIBADAFMAACAQEwDQYJKoZIhvcNAQEBBQAEggEAYOrN56hGTAqMFbb5RJYoN5KciT9Ant3xX+lrCs3b/DJiu50LXXbXCD3saPK2ceYz+VM/OX79910CBGM/gySr55Q8RG6RFW/Yn2HQ2YwA1oACIToISZy4BkwUWGHAyQQ0vRgixUGWY2MCFkyYZtjCYP/hwF1icES0h5q885S8/j9h1agbGOk6fqOzoP8GEEtdGP8usE8bcXXckzHlBHGM8J9M3JkWPDwpbvOOsxxgoUPo3MU4pQCKV+t9lmDbz5NrG4aNj99zh1Ldchg//i1jov95Iet9zv8NRxtCU6c0XtoIDft062CTYztXuP63zw2n23fvu+fLt7XI5e/OIqKWEjB8BgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBBMDriSaIF1oqJDXQFVo7trgFCsvJHk0dd9Sntig57+WGprH/XxrlcioTMUtpwUds3EEb92nntDtM/X5nmJv3g4h40Qtcm9xbQnnPVHpGDhjunTzrsDKEToMveV18ZHim3Opg==]',
  }
  notify { 'hello from the puppet server':
  }
  firewall { '000 accept all icmp requests':
    proto => 'icmp',
    jump  => 'accept',
  }
}
