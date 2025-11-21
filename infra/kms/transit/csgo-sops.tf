resource "vault_transit_secret_backend_key" "csgo-sops" {
  backend = vault_mount.transit.path
  name    = "csgo-sops"
}
