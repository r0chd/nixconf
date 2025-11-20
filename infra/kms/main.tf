data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "vault" {
  address = "https://vault.r0chd.pl"
  token   = data.sops_file.secrets.data["vault.root"]
}

module "userpass" {
  source  = "./userpass"
  secrets = data.sops_file.secrets.data
}
