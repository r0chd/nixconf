resource "garage_key" "nextcloud" {
  name = "nextcloud"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "nextcloud" {}

resource "garage_bucket_key" "nextcloud-key" {
  bucket_id     = garage_bucket.nextcloud.id
  access_key_id = garage_key.nextcloud.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "nextcloud" {
  bucket_id     = garage_bucket.nextcloud.id
  access_key_id = garage_key.nextcloud.access_key_id
  alias         = "nextcloud"
}

output "nextcloud-id" {
  value = garage_bucket.nextcloud.id
}

output "nextcloud-access-key-id" {
  value = garage_key.nextcloud.access_key_id
}

output "nextcloud-secret-access-key" {
  value     = garage_key.nextcloud.secret_access_key
  sensitive = true
}
