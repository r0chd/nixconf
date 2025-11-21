resource "vault_jwt_auth_backend" "oidc" {
  path               = "oidc"
  oidc_discovery_url = "https://dex.r0chd.pl"
  oidc_client_id     = "vault"
  oidc_client_secret = var.secrets["vault_client_secret"]
}

variable "secrets" {
  type      = map(any)
  sensitive = true
}
