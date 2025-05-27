# install openvox agent
class profile::vox_agent {
  file { '/etc/yum.repos.d/openvox8-release.repo':
    ensure  => file,
    content => "[openvox8]
name=OpenVox 8 Repository fedora 41 - ${'basearch'}
baseurl=https://yum.voxpupuli.org/openvox8/fedora/41/${'basearch'}
gpgkey=file:///etc/pki/rpm-gpg/GPG-KEY-openvox-openvox8-release
enabled=1
gpgcheck=1",
  }

# install openvox agent
  package { 'openvox_agent':
    ensure => 'latest',
  }
}
