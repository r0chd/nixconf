{
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
      packages = [ ];
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
