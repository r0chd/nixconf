data "sops_file" "secrets" {
  source_file = "secrets/secrets.yaml"
}

provider "forgejo" {
  alias     = "apiToken"
  host      = "https://forgejo.r0chd.pl"
  api_token = data.sops_file.secrets.data["forgejo_api_token"]
}

resource "forgejo_repository" "nixconf" {
  provider       = forgejo.apiToken
  name           = "nixconf"
  description    = "Modular config for my system and HA k3s cluster"
  default_branch = "master"
}

resource "forgejo_repository" "hyprwire-zig" {
  provider       = forgejo.apiToken
  name           = "hyprwire-zig"
  description    = "Zig implementation of hyprwire protocol"
  default_branch = "master"
}

resource "forgejo_repository" "znix-parser" {
  provider       = forgejo.apiToken
  name           = "znix-parser"
  default_branch = "master"
}

resource "forgejo_repository" "whydotool" {
  provider       = forgejo.apiToken
  name           = "whydotool"
  description    = "Wayland-native command-line automation tool"
  default_branch = "master"
}

resource "forgejo_repository" "CV" {
  provider       = forgejo.apiToken
  name           = "CV"
  default_branch = "master"
}

resource "forgejo_repository" "portfolio" {
  provider       = forgejo.apiToken
  name           = "portfolio"
  default_branch = "master"
}

resource "forgejo_repository" "freedesktop-sound" {
  provider       = forgejo.apiToken
  name           = "freedesktop-sound"
  description    = "A rust freedesktop sound lookup implementation"
  default_branch = "master"
}

# resource "forgejo_organization" "mox-desktop" {
#   provider = forgejo.apiToken
#   name     = "mox-desktop"
# }
