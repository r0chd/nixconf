resource "vault_jwt_auth_backend_role" "homelab" {
  backend   = vault_jwt_auth_backend.oidc.path
  role_name = "homelab"

  allowed_redirect_uris = [
    "https://vault.r0chd.pl/ui/vault/auth/oidc/oidc/callback",
    "https://vault.r0chd.pl/v1/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  bound_audiences = ["vault"]
  user_claim      = "email"
  groups_claim    = "groups"

  bound_claims = {
    groups = "r0chd-homelab"
  }

  token_policies  = ["homelab-vault-policy"]
  oidc_scopes     = ["email", "groups"]

  depends_on = [vault_jwt_auth_backend.oidc]
}
