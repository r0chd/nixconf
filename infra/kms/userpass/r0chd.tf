resource "vault_generic_endpoint" "r0chd" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/r0chd"
  ignore_absent_fields = true

  data_json = jsonencode({
    token_policies = ["developer-vault-policy"]
    password       = var.secrets["vault.users.r0chd"]
  })
}

