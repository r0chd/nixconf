data "sops_file" "secrets" {
  source_file = "${path.module}/secrets/secrets.yaml"
}

provider "cloudflare" {
  api_token  = data.sops_file.secrets.data["cloudflare.api-token"]
}
