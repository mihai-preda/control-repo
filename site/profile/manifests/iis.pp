# IIS profile
class profile::iis {
  windowsfeature { 'Web-WebServer':
    ensure             => present,
    installsubfeatures => true,
  }
}
