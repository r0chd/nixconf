resource "vault_github_auth_backend" "mox-desktop" {
  path         = "github"
  organization = "mox-desktop"
}

resource "vault_github_team" "dev" {
  backend  = vault_github_auth_backend.mox-desktop.path
  team     = "dev"
  policies = ["dev-policy"]
}
