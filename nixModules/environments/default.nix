{ lib, ... }:
{
  imports = [
    ./wayland
    ./x11
  ];

  options.window-manager = {
    enable = lib.mkEnableOption "Enable";
    backend = lib.mkOption {
      type = lib.types.enum [
        "X11"
        "Wayland"
      ];
    };
    name = lib.mkOption {
      type = lib.types.enum [
        "Hyprland"
        "sway"
        "niri"
        "i3"
        "gamescope"
      ];
    };
  };
}
