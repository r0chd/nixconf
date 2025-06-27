{
  pkgs,
  lib,
  config,
  system_type,
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
    ./gnome
  ];

  config = lib.mkIf (system_type == "desktop") {
    home = {
      packages = with pkgs; [
        wlr-randr
        wl-clipboard
      ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
