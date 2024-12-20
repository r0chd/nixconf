{ lib, config, ... }:
let
  cfg = config.window-manager;
in
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

  config.environment.loginShellInit = lib.mkIf cfg.enable ''
    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        ${if cfg.name == "gamescope" then "Hyprland" else cfg.name}
    fi
  '';
}
