# base profile
class profile::base {
  exec { 'set locale':
    command => '/bin/localectl set-locale LANG=en_GB',
    unless  => '/bin/localectl | /bin/grep -q "LANG=en_GB"',
  }
  package { 'htop':
    ensure => 'present',
  }
  package { 'rsync':
    ensure => 'present',
  }
  file { 'wheel':
    owner   => root,
    group   => root,
    mode    => '0440',
    path    => '/etc/sudoers.d/wheel',
    content => "%wheel ALL=(ALL) NOPASSWD: ALL\n",
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
