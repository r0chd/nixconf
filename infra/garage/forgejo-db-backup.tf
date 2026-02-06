resource "garage_key" "forgejo-db-backup" {
  name = "forgejo-db-backup"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "forgejo-db-backup" {}

resource "garage_bucket_key" "forgejo-db-backup-key" {
  bucket_id     = garage_bucket.forgejo-db-backup.id
  access_key_id = garage_key.forgejo-db-backup.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "forgejo-db-backup" {
  bucket_id     = garage_bucket.forgejo-db-backup.id
  access_key_id = garage_key.forgejo-db-backup.access_key_id
  alias         = "forgejo-db-backup"
}

output "forgejo-db-backup-id" {
  value = garage_bucket.forgejo-db-backup.id
}

output "forgejo-db-backup-access-key-id" {
  value = garage_key.forgejo-db-backup.access_key_id
}

output "forgejo-db-backup-secret-access-key" {
  value     = garage_key.forgejo-db-backup.secret_access_key
  sensitive = true
}

resource "kubernetes_secret" "forgejo-db-backup" {
  metadata {
    name      = "forgejo-db-backup-s3-credentials"
    namespace = "forgejo"
  }

  data = {
    access-key-id     = garage_key.forgejo-db-backup.access_key_id
    secret-access-key = garage_key.forgejo-db-backup.secret_access_key
  }
}
