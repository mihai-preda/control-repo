# IIS profile
class profile::iis {
  windowsfeature { 'Telnet-Client	':
    ensure                 => present,
    installmanagementtools => true,
    installsubfeatures     => true,
  }
}
