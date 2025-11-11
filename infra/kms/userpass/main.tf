resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

variable "secrets" {
  type      = map(any)
  sensitive = true
}
