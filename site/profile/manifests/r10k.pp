# web hook with r10k
class profile::r10k {
  class { 'r10k':
    remote => 'https://github.com/mihai-preda/control-repo.git',
  }
  class { 'r10k::webhook::config':
    use_mcollective => false,
  }

  class { 'r10k::webhook':
    ensure => true,
    server => {
      protected => false,
    },
  }
