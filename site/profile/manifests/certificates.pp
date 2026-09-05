# TLS certificates from Let's Encrypt, validated via DNS-01 against the
# Cloudflare-hosted preda.ca zone, so nodes need no inbound exposure and no
# pre-staged key material. Consumers must require this class and point at
# /etc/letsencrypt/live/<fqdn>/{cert,privkey,chain}.pem.
# @param cloudflare_api_token - Cloudflare API token with Zone:DNS:Edit on preda.ca (eyaml-encrypted in Hiera)
# @param email - contact email registered with Let's Encrypt for expiry notices
# @param staging - use the staging endpoint (untrusted certs, generous rate limits) instead of production
# @param enabled - manage certbot at all. Set false on a node where certbot is
#   temporarily uninstallable; already-issued certs under /etc/letsencrypt stay
#   on disk and consumers keep serving them, but nothing renews them.
class profile::certificates (
  String[1] $cloudflare_api_token,
  String[1] $email,
  Boolean   $staging = false,
  Boolean   $enabled = true,
) {
  if $enabled {
    $acme_server = $staging ? {
      true    => 'https://acme-staging-v02.api.letsencrypt.org/directory',
      default => 'https://acme-v02.api.letsencrypt.org/directory',
    }

    class { 'letsencrypt':
      email  => $email,
      config => {
        'server' => $acme_server,
      },
    }

    class { 'letsencrypt::plugin::dns_cloudflare':
      api_token => $cloudflare_api_token,
    }

    # try-reload-or-restart is a no-op while httpd isn't running yet, which is
    # the case on the first agent run (the cert is issued before the vhost).
    letsencrypt::certonly { $facts['networking']['fqdn']:
      domains              => [$facts['networking']['fqdn']],
      plugin               => 'dns-cloudflare',
      manage_cron          => true,
      deploy_hook_commands => ['/usr/bin/systemctl try-reload-or-restart httpd'],
    }
  }
}
