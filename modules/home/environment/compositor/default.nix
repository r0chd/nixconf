{
  pkgs,
  lib,
  config,
  profile,
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

  config = lib.mkIf (profile == "desktop") {
    home = {
      packages = builtins.attrValues { inherit (pkgs) wlr-randr wl-clipboard; };
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
