{
  config,
  lib,
  systemUsers,
  ...
}:
let
  cfg = config.virtualisation;
in
{
  imports = [
    ./distrobox
  ];

  options.virtualisation = {
    virt-manager.enable = lib.mkEnableOption "Enable virt-manager";
  };

  config = {
    virtualisation.libvirtd = lib.mkIf cfg.virt-manager.enable {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
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
