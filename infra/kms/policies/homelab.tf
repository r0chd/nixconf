resource "vault_policy" "homelab_vault_policy" {
  name = "homelab-vault-policy"

  policy = <<EOT
    path "transit/decrypt/fi-sops" {  
      capabilities = ["update"]  
    }  
    path "transit/encrypt/fi-sops" {  
      capabilities = ["update"]  
    }  
  EOT  
}
