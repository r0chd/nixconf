resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_policy" "developer_vault_policy" {
  name = "developer-vault-policy"

  policy = <<EOT
    path "transit/decrypt/sops-key" {  
      capabilities = ["update"]  
    }  
    path "transit/encrypt/sops-key" {  
      capabilities = ["update"]  
    }  
  EOT  
}

resource "vault_generic_endpoint" "r0chd" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/r0chd"
  ignore_absent_fields = true

  data_json = jsonencode({
    token_policies = ["developer-vault-policy"]
    password       = data.sops_file.secrets.data["vault.users.r0chd"]
  })
}

resource "vault_mount" "transit" {
  path = "transit"
  type = "transit"
}

resource "vault_transit_secret_backend_key" "sops" {
  backend = vault_mount.transit.path
  name    = "sops-key"
}
