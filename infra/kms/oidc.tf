resource "vault_identity_oidc_client" "ingress" {
  name = "ingress"

  redirect_uris = [
    "https://your-ingress-domain.com/oauth2/callback"
  ]

  assignments = ["allow_all"]

  id_token_ttl     = 3600
  access_token_ttl = 1800
}
