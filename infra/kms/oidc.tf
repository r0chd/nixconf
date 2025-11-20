resource "vault_jwt_auth_backend" "oidc" {  
  path               = "oidc"  
  oidc_discovery_url = "https://dex.r0chd.pl"  
  oidc_client_id     = "vault"  
  oidc_client_secret = data.sops_file.secrets.data["vault_client_secret"]  
  default_role       = "dex"  
}  
  
resource "vault_jwt_auth_backend_role" "dex" {  
  backend   = vault_jwt_auth_backend.oidc.path  
  role_name = "dex"  
  
  allowed_redirect_uris = [  
    "https://vault.r0chd.pl/ui/vault/auth/oidc/oidc/callback",  
    "https://vault.r0chd.pl/v1/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]  
  bound_audiences = ["vault"]  
  user_claim      = "email"  
  token_policies  = ["default", "developer-vault-policy"]
  oidc_scopes     = ["email"]
    
  depends_on = [vault_jwt_auth_backend.oidc]  
}
