data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "vault" {
  address = "https://vault.r0chd.pl"
  token   = data.sops_file.secrets.data["vault.root"]
}

module "userpass" {
  source  = "./userpass"
  secrets = data.sops_file.secrets.data
}

module "policies" {
  source = "./policies"
}

module "oidc" {
  source = "./oidc"
  secrets = data.sops_file.secrets.data
}

module "transit" {
  source = "./transit"
}
