resource "vault_transit_secret_backend_key" "fi-sops" {
  backend = vault_mount.transit.path
  name    = "fi-sops"
}
