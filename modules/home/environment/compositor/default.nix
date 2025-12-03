{
  pkgs,
  lib,
  profile,
  inputs,
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
      packages = [ inputs.wl-clipboard-zig.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
