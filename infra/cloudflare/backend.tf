terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "r0chd"

    workspaces {
      name = "cloudflare"
    }
  }
}
