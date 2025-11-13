resource "garage_key" "vaultwarden" {
  name = "vaultwarden"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "vaultwarden" {}

resource "garage_bucket_key" "vaultwarden-key" {
  bucket_id     = garage_bucket.vaultwarden.id
  access_key_id = garage_key.vaultwarden.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "vaultwarden" {
  bucket_id     = garage_bucket.vaultwarden.id
  access_key_id = garage_key.vaultwarden.access_key_id
  alias         = "vaultwarden"
}

output "vaultwarden-id" {
  value = garage_bucket.vaultwarden.id
}

output "vaultwarden-access-key-id" {
  value = garage_key.vaultwarden.access_key_id
}

output "vaultwarden-secret-access-key" {
  value     = garage_key.vaultwarden.secret_access_key
  sensitive = true
}
