resource "vault_generic_endpoint" "admin" {
  path                 = "auth/${vault_auth_backend.userpass.path}/users/admin"
  ignore_absent_fields = true

  data_json = jsonencode({
    token_policies = ["admin-vault-policy"]
    password       = var.secrets["vault.users.admin"]
  })
}

