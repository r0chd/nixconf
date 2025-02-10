{
  pkgs,
  inputs,
  lib,
  config,
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
  ];

  options.environment = {
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
  };

  config = {
    nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];

    wayland.windowManager = {
      hyprland.settings.input.monitor =
        cfg.outputs
        |> lib.mapAttrsToList (
          name: value:
          "${name}, ${toString value.dimensions.width}x${toString value.dimensions.height}@${toString value.refresh}, ${toString value.position.x}x${toString value.position.y}, ${toString value.scale}"
        );

      sway.config.output =
        config.environment.outputs
        |> lib.mapAttrs (
          name: value: {
            position = "${toString value.position.x} ${toString value.position.y}";
            resolution = "${toString value.dimensions.width}x${toString value.dimensions.height}@${toString value.refresh}Hz";
            scale = "${toString value.scale}";
          }
        );
    };

    programs.niri.settings.outputs = lib.mapAttrs (name: value: {
      scale = value.scale;
      mode = {
        width = value.dimensions.width;
        height = value.dimensions.height;
        refresh = value.refresh;
      };
      position = value.position;
    }) config.environment.outputs;

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
  };
}
