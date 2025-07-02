# base profile
class profile::base {
  exec { 'set locale':
    command => '/bin/localectl set-locale LANG=en_GB',
  }
  package { 'htop':
    ensure => 'present',
  }
  notify { 'hello from the puppet server':
  }

  file { 'sudo_rule_nopw':
    owner => root,
    group => root,
    mode  => '0440',
    path  => '/etc/sudoers.d/wheel',
    line  => '%wheel ALL=(ALL) NOPASSWD: ALL',
  }
  firewall { '000 accept all icmp requests':
    proto => 'icmp',
    jump  => 'accept',
  }
}
