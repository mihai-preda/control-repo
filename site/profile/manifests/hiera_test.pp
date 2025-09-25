# /etc/puppetlabs/code/environments/production/modules/profile/manifests/hiera_test.pp
# @param ssl add to hiera as follows: profile::hiera_test::ssl: false or true
# @param backups_enabled see below example
# @param site_alias also see below. This documentation fixes mild error
# showing when $vars don't have docu.
class profile::hiera_test (
  Boolean             $ssl,
  Boolean             $backups_enabled,
  Optional[String[1]] $site_alias = undef,
) {
  file { '/tmp/hiera_test.txt':
    ensure  => file,
    content => @("END"),
               Data from profile::hiera_test
               -----
               profile::hiera_test::ssl: ${ssl}
               profile::hiera_test::backups_enabled: ${backups_enabled}
               profile::hiera_test::site_alias: ${site_alias}
               |END
    owner   => root,
    mode    => '0644',
  }
}
