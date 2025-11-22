resource "vault_jwt_auth_backend_role" "csgo" {
  backend   = vault_jwt_auth_backend.oidc.path
  role_name = "csgo"

  allowed_redirect_uris = [
    "https://vault.r0chd.pl/ui/vault/auth/oidc/oidc/callback",
    "https://vault.r0chd.pl/v1/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  bound_audiences = ["vault"]
  user_claim      = "email"
  groups_claim    = "groups"

  oidc_scopes = ["email", "groups"]

  bound_claims = {
    groups = "test"
  }

  token_policies  = ["csgo-vault-policy"]

  depends_on = [vault_jwt_auth_backend.oidc]
}
