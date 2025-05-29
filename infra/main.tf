locals {
  ipv4 = "192.168.30.115"
}

module "system-build" {
  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = ".#nixosConfigurations.laptop-thinkpad.config.system.build.toplevel"
}

module "disko" {
  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = ".#nixosConfigurations.laptop-thinkpad.config.system.build.diskoScript"
}

module "install" {
  source            = "github.com/nix-community/nixos-anywhere//terraform/install"
  nixos_system      = module.system-build.result.out
  nixos_partitioner = module.disko.result.out
  target_host       = local.ipv4
}
