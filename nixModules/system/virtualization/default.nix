{ config, lib, ... }:
{
  options.virtualisation.enable = lib.mkEnableOption "Enable virtualisation";

  config = lib.mkIf config.virtualisation.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    programs.virt-manager.enable = true;
    users.users = lib.genAttrs (builtins.attrNames config.systemUsers) (user: {
      extraGroups = [ "libvirtd" ];
    });
  };
}
