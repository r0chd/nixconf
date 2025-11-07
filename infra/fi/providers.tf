terraform {
  required_providers {
    garage = {
      source  = "prologin/garage"
      version = "0.0.1"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
}
