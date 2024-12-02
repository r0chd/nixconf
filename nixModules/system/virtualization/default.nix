{
  config,
  lib,
  systemUsers,
  ...
}:
let
  cfg = config.system.virtualisation;
in
{
  options.system.virtualisation.enable = lib.mkEnableOption "Enable virtualisation";

  config = lib.mkIf cfg.enable {
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
