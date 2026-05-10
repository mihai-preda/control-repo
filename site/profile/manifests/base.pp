# base profile
# @param files A hash of file resources to create, 
#where the key is the file path and the value is a hash of attributes for that file resource.
class profile::base (
  Hash $files = {},
) {
  # This dynamically creates file resources based on the Hiera hash
  $files.each |String $path, Hash $attributes| {
    file { $path:
      * => $attributes,
    }
  }
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
