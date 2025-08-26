module "deploy" {
  for_each = local.hosts

  source                     = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"
  nixos_system_attr          = ".#nixosConfigurations.${each.value.hostname}.config.system.build.toplevel"
  nixos_partitioner_attr     = ".#nixosConfigurations.${each.value.hostname}.config.system.build.diskoScript"
  target_host                = each.value.hostname
  instance_id                = each.value.hostname
  nixos_generate_config_path = "../hosts/${each.value.hostname}/hardware-configuration.nix"
}
