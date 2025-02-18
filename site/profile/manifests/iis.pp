# IIS profile
class profile::iis {
  windowsfeature { 'Web-WebServer':
    ensure                 => present,
    installmanagementtools => true,
    installsubfeatures     => true,
  }
}
