{ lib, ... }:
{
  imports = [
    ./wayland
    ./x11
  ];

  options = {
    outputs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            position = {
              x = lib.mkOption { type = lib.types.int; };
              y = lib.mkOption { type = lib.types.int; };
            };
            refresh = lib.mkOption { type = lib.types.float; };
            dimensions = {
              width = lib.mkOption { type = lib.types.int; };
              height = lib.mkOption { type = lib.types.int; };
            };
            scale = lib.mkOption {
              type = lib.types.int;
              default = 1;
            };
          };
        }
      );
      default = { };
    };

    environment = {
      window-manager = {
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
    };
  };
}
