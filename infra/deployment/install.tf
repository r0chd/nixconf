module "deploy" {
  for_each = local.hosts

  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = "../..#nixosConfigurations.${each.key}.config.system.build.toplevel"
  nixos_partitioner_attr = "../..#nixosConfigurations.${each.key}.config.system.build.diskoScript"

  target_host = each.value.ip

  instance_id                = each.key
  nixos_generate_config_path = "../../hosts/${each.key}/hardware-configuration.nix"

  extra_files_script = "${path.module}/copy.sh"

  debug_logging = true  
}
