{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.environment;
in
{
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (cfg.session == "Wayland") {
    home = {
      packages = with pkgs; [
        wl-clipboard
        wayland
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
