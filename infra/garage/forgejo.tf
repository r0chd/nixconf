resource "garage_key" "forgejo" {
  name = "forgejo"

  lifecycle {
    ignore_changes = [permissions]
  }
}

resource "garage_bucket" "forgejo" {}

resource "garage_bucket_key" "forgejo-key" {
  bucket_id     = garage_bucket.forgejo.id
  access_key_id = garage_key.forgejo.access_key_id

  read  = true
  write = true

  # Forgejo requires owner permissions for the BucketExists() check during initialization.  
  # This is only needed at startup; normal operations only use read/write permissions. 
  owner = true
}

resource "garage_bucket_local_alias" "forgejo" {
  bucket_id     = garage_bucket.forgejo.id
  access_key_id = garage_key.forgejo.access_key_id
  alias         = "forgejo"
}

output "forgejo-id" {
  value = garage_bucket.forgejo.id
}

output "forgejo-access-key-id" {
  value = garage_key.forgejo.access_key_id
}

output "forgejo-secret-access-key" {
  value     = garage_key.forgejo.secret_access_key
  sensitive = true
}

resource "kubernetes_secret" "forgejo" {
  metadata {
    name      = "forgejo-s3-credentials"
    namespace = "forgejo"
  }

  data = {
    access_key_id     = garage_key.forgejo.access_key_id
    secret_access_key = garage_key.forgejo.secret_access_key
  }
}
