resource "garage_key" "quickwit" {
  name = "quickwit"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "quickwit" {}

resource "garage_bucket_key" "quickwit-key" {
  bucket_id     = garage_bucket.quickwit.id
  access_key_id = garage_key.quickwit.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "quickwit" {
  bucket_id     = garage_bucket.quickwit.id
  access_key_id = garage_key.quickwit.access_key_id
  alias         = "quickwit"
}

output "quickwit-id" {
  value = garage_bucket.quickwit.id
}

output "quickwit-access-key-id" {
  value = garage_key.quickwit.access_key_id
}

output "quickwit-secret-access-key" {
  value     = garage_key.quickwit.secret_access_key
  sensitive = true
}
