data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "garage" {
  host   = "admin.garage.r0chd.pl"
  scheme = "https"
  token  = data.sops_file.secrets.data["garage.admin-token"]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

output "garage_token" {
  value     = data.sops_file.secrets.data["garage.admin-token"]
  sensitive = true
}
