{
  config,
  lib,
  systemUsers,
  ...
}:
{
  options.virtualisation.enable = lib.mkEnableOption "Enable virtualisation";

  config = lib.mkIf config.virtualisation.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    programs.virt-manager.enable = true;
    users.users = lib.genAttrs (builtins.attrNames systemUsers) (user: {
      extraGroups = [ "libvirtd" ];
    });
  };
}
