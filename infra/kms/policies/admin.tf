resource "vault_policy" "admin_vault_policy" {
  name = "admin-vault-policy"

  policy = <<EOT
    # Full access to all secrets
    path "*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
    
    # Manage auth backends (userpass, github, etc.)
    path "auth/*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
    
    # Manage policies
    path "sys/policy/*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
    
    # Manage mounts (transit, kv, etc.)
    path "sys/mounts/*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
    
    # Manage tokens
    path "auth/token/*" {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
EOT
}
