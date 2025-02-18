# IIS profile
class profile::iis {
  $iis_features = ['Web-Server','Web-WebServer','Web-Asp-Net48','Web-ISAPI-Ext','Web-ISAPI-Filter','NET-Framework-48-ASPNET',
  'WAS-NET-Environment','Web-Http-Redirect','Web-Filtering','Web-Mgmt-Console','Web-Mgmt-Tools']
  windowsfeature { $iis_features:
    ensure => present,
  }
}
