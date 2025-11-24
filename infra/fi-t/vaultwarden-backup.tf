resource "garage_key" "vaultwarden-backup" {
  name = "vaultwarden-backup"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "vaultwarden-backup" {}

resource "garage_bucket_key" "vaultwarden-backup-key" {
  bucket_id     = garage_bucket.vaultwarden-backup.id
  access_key_id = garage_key.vaultwarden-backup.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "vaultwarden-backup" {
  bucket_id     = garage_bucket.vaultwarden-backup.id
  access_key_id = garage_key.vaultwarden-backup.access_key_id
  alias         = "vaultwarden-backup"
}

output "vaultwarden-backup-id" {
  value = garage_bucket.vaultwarden-backup.id
}

output "vaultwarden-backup-access-key-id" {
  value = garage_key.vaultwarden-backup.access_key_id
}

output "vaultwarden-backup-secret-access-key" {
  value     = garage_key.vaultwarden-backup.secret_access_key
  sensitive = true
}
