resource "garage_key" "known-hosts" {
  name = "known-hosts"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "known-hosts" {}

resource "garage_bucket_key" "known-hosts-key" {
  bucket_id     = garage_bucket.known-hosts.id
  access_key_id = garage_key.known-hosts.access_key_id

  read  = true
  write = true
}

resource "garage_bucket_local_alias" "known-hosts" {
  bucket_id     = garage_bucket.known-hosts.id
  access_key_id = garage_key.known-hosts.access_key_id
  alias         = "known-hosts"
}

output "known-hosts-id" {
  value = garage_bucket.known-hosts.id
}

output "known-hosts-access-key-id" {
  value = garage_key.known-hosts.access_key_id
}

output "known-hosts-secret-access-key" {
  value     = garage_key.known-hosts.secret_access_key
  sensitive = true
}
