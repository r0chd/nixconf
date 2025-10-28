data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "garage" {
  host   = "admin.example.com"
  scheme = "http"
  token  = data.sops_file.secrets.data["garage.admin_token"]
}

output "garage_token" {
  value     = data.sops_file.secrets.data["garage.admin_token"]
  sensitive = true
}
