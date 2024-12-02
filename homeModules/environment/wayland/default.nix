{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.environment.window-manager;
in
{
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (cfg.enable && cfg.backend == "Wayland") {
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
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
      config.common.default = "*";
    };
  };
}
