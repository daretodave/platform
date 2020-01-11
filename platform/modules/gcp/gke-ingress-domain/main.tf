resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address = var.acme_email
}

output "acme_registration" {
  value = acme_registration.reg
}

resource "google_compute_global_address" "ingress_ip" {
  name = "${var.name}-address"
}

resource "google_dns_record_set" "dns" {
  name = "${var.domain}."
  type = "A"
  ttl = 300
  managed_zone = var.domain_zone

  rrdatas = [
    google_compute_global_address.ingress_ip.address]
}

resource "acme_certificate" "ingress_cert" {
  common_name = var.domain
  dns_challenge {
    provider = "gcloud"
    config = {
      GCE_PROJECT = var.project
    }
  }
  key_type = "2048"
  must_staple = false
  min_days_remaining = 30
  account_key_pem = acme_registration.reg.account_key_pem
}
