data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "garage" {
  host   = "admin.garage.r0chd.pl"
  scheme = "https"
  token  = data.sops_file.secrets.data["admin-token"]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

output "garage_token" {
  value     = data.sops_file.secrets.data["admin-token"]
  sensitive = true
}

resource "kubernetes_secret" "garage" {
  metadata {
    name      = "garage-secrets"
    namespace = "default"
  }

  data = {
    rpc-secret = data.sops_file.secrets.data["rpc-secret"]
    admin-token = data.sops_file.secrets.data["admin-token"]
    metrics-token = data.sops_file.secrets.data["metrics-token"]
  }
}
