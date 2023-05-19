# =============================================================================
# MX RECORDS
# =============================================================================

resource "cloudflare_record" "mx1" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "lsferreira.net"
  value = "mail.protonmail.ch"
  priority = 10
  type = "MX"
}

resource "cloudflare_record" "mx2" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "lsferreira.net"
  value = "mailsec.protonmail.ch"
  priority = 20
  type = "MX"
}


# =============================================================================
# SPF / DMARC
# =============================================================================

resource "cloudflare_record" "spf" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "lsferreira.net"
  value = "v=spf1 include:mx.ovh.com include:_spf.protonmail.ch mx ~all"
  type = "TXT"
}

resource "cloudflare_record" "dmarc" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "_dmarc"
  value = "v=DMARC1; p=reject; sp=reject; pct=100; rua=mailto:dmarc@lsferreira.net; ruf=mailto:dmarc@lsferreira.net; fo=1:s:d; adkim=r; aspf=r"
  type = "TXT"
}

# =============================================================================
# DKIM
# =============================================================================

resource "cloudflare_record" "dkim1" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "protonmail._domainkey"
  value = "protonmail.domainkey.d3o6sspqrfqz73aqmw6ghj2f22kp3ob77j72axb34nj3dnhp4aqxa.domains.proton.ch"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "dkim2" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "protonmail2._domainkey"
  value = "protonmail2.domainkey.d3o6sspqrfqz73aqmw6ghj2f22kp3ob77j72axb34nj3dnhp4aqxa.domains.proton.ch"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "dkim3" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "protonmail3._domainkey"
  value = "protonmail3.domainkey.d3o6sspqrfqz73aqmw6ghj2f22kp3ob77j72axb34nj3dnhp4aqxa.domains.proton.ch"
  proxied = false
  type = "CNAME"
}

# =============================================================================
# MANUAL CONFIGURATION
# =============================================================================

resource "cloudflare_record" "smtp" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "smtp"
  value = "ssl0.ovh.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "pop3" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "pop3"
  value = "ssl0.ovh.net"
  proxied = false
  type = "CNAME"
}

# Alias to pop3
resource "cloudflare_record" "pop" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "pop"
  value = "pop3.lsferreira.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "imap" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "imap"
  value = "ssl0.ovh.net"
  proxied = false
  type = "CNAME"
}


# =============================================================================
# AUTO CONFIGURATION
# =============================================================================

resource "cloudflare_record" "autoconfig" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "autoconfig"
  value = "mailconfig.ovh.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "autodiscover" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "autodiscover"
  value = "mailconfig.ovh.net"
  proxied = false
  type = "CNAME"
}

resource "cloudflare_record" "srv_autodiscover" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name    = "_autodiscover._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_autodiscover._tcp._autodiscover"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 443
    target   = "mailconfig.ovh.net"
  }
}

resource "cloudflare_record" "srv_smtp" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name    = "_submission._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_submission._tcp._submission"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 465
    target   = "smtp.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_pop3" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name    = "_pop3._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_pop3._tcp._pop3"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 110
    target   = "pop3.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_pop3s" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name    = "_pop3s._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_pop3s._tcp._pop3s"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 995
    target   = "pop3.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_imap" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name    = "_imap._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_imap._tcp._imap"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 143
    target   = "imap.lsferreira.net"
  }
}

resource "cloudflare_record" "srv_imaps" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name    = "_imaps._tcp"
  type    = "SRV"

  data {
    name     = "lsferreira.net"
    service  = "_imaps._tcp._imaps"
    proto    = "_tcp"
    priority = 0
    weight   = 0
    port     = 993
    target   = "imap.lsferreira.net"
  }
}


# =============================================================================
# WEBMAIL
# =============================================================================

resource "cloudflare_record" "webmail" {
  zone_id = data.cloudflare_zones.lsferreira_net.id
  name = "webmail"
  value = "ssl0.ovh.net"
  type = "CNAME"
}
