variable "target_ip" {
  type = string
}

variable "machine_name" {
  type = string
}

locals {
  ipv4 = var.target_ip
}

module "system-build" {
  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = ".#nixosConfigurations.${var.machine_name}.config.system.build.toplevel"
}

module "disko" {
  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = ".#nixosConfigurations.${var.machine_name}.config.system.build.diskoScript"
}

module "install" {
  source                     = "github.com/nix-community/nixos-anywhere//terraform/install"
  nixos_system               = module.system-build.result.out
  nixos_partitioner          = module.disko.result.out
  target_host                = local.ipv4
  nixos_generate_config_path = "../hosts/${var.machine_name}/hardware-configuration.nix"
  #extra_files_script = "${path.module}/extra"
}
