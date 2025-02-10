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
    enable = lib.mkEnableOption "Virtualisation";
    virt-manager.enable = lib.mkEnableOption "Enable virt-manager";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    users.users =
      systemUsers
      |> lib.mapAttrs (
        user: value: {
          extraGroups = lib.mkIf value.root.enable [
            "libvirtd"
          ];
        }
      );

    programs.virt-manager.enable = cfg.virt-manager.enable;
  };
}
