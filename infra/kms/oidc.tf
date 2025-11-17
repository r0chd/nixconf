resource "vault_identity_oidc_key" "oidc_key" {
 name               = "oidc-key"
 rotation_period    = 3600
 algorithm          = "RS256"
 allowed_client_ids = ["*"]
 verification_ttl   = 7200
}

resource "vault_identity_oidc" "oidc" {}

resource "vault_identity_oidc_role" "role" {
 key  = vault_identity_oidc_key.oidc_key.name
 name = "oidc-role"
template = <<EOF
{
 "email": {{identity.entity.metadata.email}},
 "username": {{identity.entity.name}}
}
EOF
 ttl = 3600
}

resource "vault_policy" "jwt" {
 name   = "jwt"
 policy = <<EOF
path "/identity/oidc/token/my-role" {
   capabilities = ["read"]
}
EOF
}
