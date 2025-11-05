resource "garage_key" "moxpaper" {
  name = "moxpaper"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "moxpaper" {}

resource "garage_bucket_key" "moxpaper-key" {
  bucket_id     = garage_bucket.moxpaper.id
  access_key_id = garage_key.moxpaper.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "moxpaper" {
  bucket_id     = garage_bucket.moxpaper.id
  access_key_id = garage_key.moxpaper.access_key_id
  alias         = "moxpaper"
}

output "moxpaper-id" {
  value = garage_bucket.moxpaper.id
}

output "moxpaper-access-key-id" {
  value = garage_key.moxpaper.access_key_id
}

output "moxpaper-secret-access-key" {
  value     = garage_key.moxpaper.secret_access_key
  sensitive = true
}
