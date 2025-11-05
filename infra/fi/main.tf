data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "garage" {
  host   = "admin.garage.r0chd.pl"
  scheme = "https"
  token  = data.sops_file.secrets.data["garage.admin_token"]
}

provider "vault" {
  address = "https://vault.r0chd.pl"
  token   = data.sops_file.secrets.data["vault.root"]
}

output "garage_token" {
  value     = data.sops_file.secrets.data["garage.admin_token"]
  sensitive = true
}
