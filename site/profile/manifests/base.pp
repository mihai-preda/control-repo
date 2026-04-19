# base profile
class profile::base {
  exec { 'set locale':
    command => '/bin/localectl set-locale LANG=en_GB',
  }
  package { 'htop':
    ensure => 'present',
  }
  package { 'rsync':
    ensure => 'present',
  }
  notify { 'hello from the puppet server':
  }
  file { 'wheel':
    owner   => root,
    group   => root,
    mode    => '0440',
    path    => '/etc/sudoers.d/wheel',
    content => '%wheel ALL=(ALL) NOPASSWD: ALL',
  }
  firewall { '000 accept all icmp requests':
    proto => 'icmp',
    jump  => 'accept',
  }
  if $facts['is_virtual'] == false {
    package { 'pciutils':
      ensure => 'present',
    }
    package { 'usbutils':
      ensure => 'present',
    }
  }
}
