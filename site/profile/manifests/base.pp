# base profile
class profile::base {
  exec { 'set locale':
    command => '/bin/localectl set-locale LANG=en_GB',
  }
  package { 'htop':
    ensure => 'present',
  }
  if $facts['os']['distro']['id'] == 'Ol' {
    package { 'iptables-nft-services':
      ensure => 'present',
    }
  } else {
    # Code to execute for any other OS family
    notify { "Unsupported OS: ${facts['os']['distro']['id']}":
      loglevel => warning,
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
  }
