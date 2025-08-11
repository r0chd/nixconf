{
  pkgs,
  lib,
  profile,
  ...
}:
{
  imports = [
    ./hyprland
    ./sway
    ./niri
    ./gnome
  ];

  config = lib.mkIf (profile == "desktop") {
    home = {
      packages = [ pkgs.wlr-randr ] ++ lib.optionals (!pkgs.lib.onGnome) [ pkgs.wl-clipboard-rs ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
