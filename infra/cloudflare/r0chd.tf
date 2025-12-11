resource "cloudflare_dns_record" "r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "www_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "www"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "vaultwarden_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "vaultwarden.r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "dex_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "dex.r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "moxwiki_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "moxwiki.r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "nextcloud_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "nextcloud.r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "portfolio_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "portfolio.r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "vault_r0chd" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "vault.r0chd.pl"
  content = "157.180.30.62"
  type = "A"
  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "wildcard" {
  zone_id = "15551841896d42f0e9489ef42a8468ee"
  name = "*"
  content = "157.180.30.62"
  type = "A"
  proxied = false
  ttl = 3600
}
