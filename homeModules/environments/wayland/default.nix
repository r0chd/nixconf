{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (config.window-manager.enable && config.window-manager.backend == "Wayland") {
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
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config.common.default = "*";
    };
  };
}
