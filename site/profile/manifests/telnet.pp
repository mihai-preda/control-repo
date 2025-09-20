# Telnet profile
class profile::telnet {
  windowsfeature { 'Telnet-Client	':
    ensure                 => present,
  }
}
