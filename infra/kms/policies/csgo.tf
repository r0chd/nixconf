resource "vault_policy" "csgo_vault_policy" {
  name = "csgo-vault-policy"

  policy = <<EOT
    path "transit/decrypt/csgo-sops" {  
      capabilities = ["update"]  
    }  
    path "transit/encrypt/csgo-sops" {  
      capabilities = ["update"]  
    }  
  EOT  
}
