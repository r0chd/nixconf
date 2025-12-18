{
  systemUsers,
  lib,
  config,
  ...
}:
let
  cfg = config.networking.wireless.networkmanager;
in
{
  options.networking.wireless.networkmanager = {
    enable = lib.mkEnableOption "networkmanager";
  };

  config = lib.mkIf cfg.enable {
    users.users =
      systemUsers
      |> lib.mapAttrs (
        _user: value: {
          extraGroups = lib.mkIf (value.root.enable) [ "networkmanager" ];
        }
      );

    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        powersave = true;
        backend = "iwd";
      };
    };
  };
}
