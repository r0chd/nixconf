resource "random_password" "oauth2-proxy-cookie-secret" {
  length           = 32
  override_special = "-_"
}
