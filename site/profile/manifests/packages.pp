# This class manages the installation of packages based on Hiera data.
# It looks up an array of package names from Hiera and ensures each one is installed.
class profile::packages {
  # Lookup packages from Hiera (merges arrays across hierarchy levels)
  $packages = lookup('profile::packages::install', {
      value_type    => Array[String],
      merge         => 'unique',   # Merges & deduplicates arrays from all levels
      default_value => [],
  })

  # Install each package
  $packages.each |String $pkg| {
    package { $pkg:
      ensure => installed,
    }
  }
}
