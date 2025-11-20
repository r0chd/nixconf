terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.4.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
}
