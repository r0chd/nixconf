resource "garage_key" "hytale-backup" {
  name = "hytale-backup"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "hytale-backup" {}

resource "garage_bucket_key" "hytale-backup-key" {
  bucket_id     = garage_bucket.hytale-backup.id
  access_key_id = garage_key.hytale-backup.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "hytale-backup" {
  bucket_id     = garage_bucket.hytale-backup.id
  access_key_id = garage_key.hytale-backup.access_key_id
  alias         = "hytale-backup"
}

output "hytale-backup-id" {
  value = garage_bucket.hytale-backup.id
}

output "hytale-backup-access-key-id" {
  value = garage_key.hytale-backup.access_key_id
}

output "hytale-backup-secret-access-key" {
  value     = garage_key.hytale-backup.secret_access_key
  sensitive = true
}

resource "kubernetes_secret" "hytale-backup" {
  metadata {
    name      = "hytale-backup-s3-credentials"
    namespace = "hytale"
  }

  data = {
    AWS_ACCESS_KEY_ID = garage_key.hytale-backup.access_key_id
    AWS_SECRET_ACCESS_KEY = garage_key.hytale-backup.secret_access_key
  }
}
