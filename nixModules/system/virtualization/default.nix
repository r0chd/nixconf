{
  config,
  lib,
  systemUsers,
  pkgs,
  ...
}:
let
  cfg = config.system.virtualisation;
in
{
  options.system.virtualisation = {
    virt-manager.enable = lib.mkEnableOption "Enable virt-manager";
    distrobox.enable = lib.mkEnableOption "Enable distrobox";
  };

  config = {
    environment.systemPackages = with pkgs; [ distrobox ];
    virtualisation = {
      podman = {
        enable = cfg.distrobox.enable;
        dockerCompat = true;
      };
      libvirtd = {
        enable = cfg.virt-manager.enable;
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
    };

    programs.virt-manager.enable = true;
    users.users =
      systemUsers
      |> lib.mapAttrs (
        user: value: {
          extraGroups = lib.mkIf value.root.enable [
            "libvirtd"
          ];
        }
      );
  };
}
