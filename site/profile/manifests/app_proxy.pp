# TLS reverse proxy fronting a backend Tomcat with this host's Let's Encrypt
# certificate, so browsers get a trusted cert while the proxy->Tomcat hop
# stays encrypted against Tomcat's own self-signed cert. This is the front end
# profile::tomcat's 8443 connector was written to sit behind.
#
# Deliberately its own vhost on its own port rather than a path on the :443
# vhost: profile::puppetboard mounts WSGIScriptAlias at '/' there, which claims
# every path and would shadow a ProxyPass.
#
# @param backend_url the Tomcat endpoint to proxy to, including trailing slash
# @param port the TLS port this vhost listens on
# @param servername vhost name; must match a SAN on this host's LE cert
class profile::app_proxy (
  Stdlib::HTTPSUrl $backend_url,
  Stdlib::Port     $port       = 8443,
  String[1]        $servername = $facts['networking']['fqdn'],
) {
  include profile::certificates

  $le_dir = "/etc/letsencrypt/live/${facts['networking']['fqdn']}"

  apache::vhost { "${servername}-app-proxy":
    servername       => $servername,
    port             => $port,
    docroot          => '/var/www/html',
    manage_docroot   => false,
    ssl              => true,
    ssl_cert         => "${le_dir}/cert.pem",
    ssl_key          => "${le_dir}/privkey.pem",
    ssl_chain        => "${le_dir}/chain.pem",
    # The backend presents a self-signed cert, so there is no CA to verify it
    # against. SSLProxyCheckPeerName is left at its httpd default (on), which
    # still binds the connection to the backend's SAN - only chain validation
    # is waived, not hostname validation.
    ssl_proxyengine  => true,
    ssl_proxy_verify => 'none',
    proxy_pass       => [
      {
        'path'         => '/',
        'url'          => $backend_url,
        'reverse_urls' => [$backend_url],
      },
    ],
    require          => Class['profile::certificates'],
  }
}
