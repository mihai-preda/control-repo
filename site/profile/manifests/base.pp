# base profile
class profile::base {
  exec { 'set locale':
    command => '/bin/localectl set-locale LANG=en_GB',
  }
  network_route { '10.24.0.0/24':
    ensure    => 'present',
    gateway   => '10.24.0.1',
    interface => 'eth1',
    netmask   => '255.255.255.0',
    network   => '10.24.0.0',
    options   => 'table 200',
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
    key    => 'AAAAC3NzaC1lZDI1NTE5AAAAIGLpIUJsD7eTM5znhRCSL5ls6hPZ6WsvWBSYV8AXv91K',
  }
  notify { 'hello from the puppet server':
  }
  firewall { '000 accept all icmp requests':
    proto => 'icmp',
    jump  => 'accept',
  }
}
