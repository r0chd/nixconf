{ lib, config, ... }:
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
      ];
    };
  };

  config.environment.loginShellInit = lib.mkIf config.window-manager.enable ''
    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        ${config.window-manager.name}
    fi
  '';
}
