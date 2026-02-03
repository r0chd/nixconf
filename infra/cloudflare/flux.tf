resource "cloudflare_r2_bucket" "flux" {
  account_id = "4cb32bb0f4c65060af66dce1d528a106"
  name = "flux"
  location = "weur"
  storage_class = "Standard"
}
