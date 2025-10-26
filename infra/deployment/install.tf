variable "ssh_source_path" {
  type        = string
  description = "Path to ssh private key used to decrypt sops secrets (only required for fresh installs)"
  default     = ""
}

module "system-build" {
  for_each = { for name, host in local.hosts : name => host if host.needs_install }

  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = ".#nixosConfigurations.${each.value.hostname}.config.system.build.toplevel"
}

module "disko" {
  for_each = { for name, host in local.hosts : name => host if host.needs_install }

  source    = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
  attribute = ".#nixosConfigurations.${each.value.hostname}.config.system.build.diskoScript"
}

module "install" {
  for_each = { for name, host in local.hosts : name => host if host.needs_install }

  source                     = "github.com/nix-community/nixos-anywhere//terraform/install"
  nixos_system               = module.system-build[each.key].result.out
  nixos_partitioner          = module.disko[each.key].result.out
  target_host                = each.value.hostname
  nixos_generate_config_path = "../hosts/${each.value.hostname}/hardware-configuration.nix"

  extra_environment = length(var.ssh_source_path) > 0 ? {
    SSH_SOURCE_PATH = var.ssh_source_path
  } : {}

  extra_files_script = "${path.module}/copy.sh"
}
