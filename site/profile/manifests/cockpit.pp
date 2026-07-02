# Cockpit web console served with the node's Let's Encrypt certificate.
# The cert/key are copied out of /etc/letsencrypt/live rather than symlinked:
# live/ and archive/ are root-only 0700, and cockpit rejects key material it
# cannot read at startup. After a renewal the copies fall out of sync and get
# refreshed (with a service restart) on the next agent run.
# @param packages - cockpit packages to install (core plus any extensions)
class profile::cockpit (
  Array[String[1]] $packages = ['cockpit'],
) {
  require profile::certificates

  $live_dir = "/etc/letsencrypt/live/${facts['networking']['fqdn']}"

  package { $packages:
    ensure => installed,
  }

  service { 'cockpit.socket':
    ensure  => running,
    enable  => true,
    require => Package[$packages],
  }

  # In ws-certs.d the alphabetically last *.cert wins, so 50-letsencrypt
  # outranks the shipped 0-self-signed.cert. links => follow is required:
  # the live/ PEMs are relative symlinks into archive/, and the default
  # (manage) would recreate them as dangling symlinks here.
  file { '/etc/cockpit/ws-certs.d/50-letsencrypt.cert':
    ensure  => file,
    source  => "${live_dir}/fullchain.pem",
    links   => 'follow',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$packages],
    notify  => Exec['restart cockpit'],
  }

  file { '/etc/cockpit/ws-certs.d/50-letsencrypt.key':
    ensure    => file,
    source    => "${live_dir}/privkey.pem",
    links     => 'follow',
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    show_diff => false,
    require   => Package[$packages],
    notify    => Exec['restart cockpit'],
  }

  # cockpit.service is socket-activated; try-restart is a no-op while the
  # web service isn't currently running.
  exec { 'restart cockpit':
    command     => '/usr/bin/systemctl try-restart cockpit.service',
    refreshonly => true,
  }
}
