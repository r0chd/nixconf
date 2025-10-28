resource "garage_key" "atuin-backup" {
  name = "atuin-backup"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "atuin-backup" {}

resource "garage_bucket_key" "atuin-backup-key" {
  bucket_id     = garage_bucket.atuin-backup.id
  access_key_id = garage_key.atuin-backup.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "atuin-backup" {
  bucket_id     = garage_bucket.atuin-backup.id
  access_key_id = garage_key.atuin-backup.access_key_id
  alias         = "atuin-backup"
}

output "atuin-backup-id" {
  value = garage_bucket.atuin-backup.id
}

output "atuin-backup-access-key-id" {
  value = garage_key.atuin-backup.access_key_id
}

output "atuin-backup-secret-access-key" {
  value     = garage_key.atuin-backup.secret_access_key
  sensitive = true
}
