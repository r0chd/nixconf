resource "garage_key" "thanos" {
  name = "thanos"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "thanos" {}

resource "garage_bucket_key" "thanos-key" {
  bucket_id     = garage_bucket.thanos.id
  access_key_id = garage_key.thanos.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "thanos" {
  bucket_id     = garage_bucket.thanos.id
  access_key_id = garage_key.thanos.access_key_id
  alias         = "thanos"
}

output "thanos-id" {
  value = garage_bucket.thanos.id
}

output "thanos-access-key-id" {
  value = garage_key.thanos.access_key_id
}

output "thanos-secret-access-key" {
  value     = garage_key.thanos.secret_access_key
  sensitive = true
}
