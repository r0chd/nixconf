# Cross compositor output configuration helper
# supported compositors:
# - niri
# - hyprland
# - sway
# - mutter
{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./mutter.nix
    ./niri.nix
    ./hyprland.nix
    ./sway.nix
  ];

  options.environment.outputs = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          primary = lib.mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether this output should be treated as the primary display.
              Used to set focus, taskbars, or default workspace placement.
            '';
          };
          position = {
            x = lib.mkOption {
              type = types.number;
              default = 0;
              description = ''
                X-coordinate of the top-left corner of the display output
                in the global layout space.
              '';
            };
            y = lib.mkOption {
              type = types.number;
              default = 0;
              description = ''
                Y-coordinate of the top-left corner of the display output
                in the global layout space.
              '';
            };
          };
          refresh = lib.mkOption {
            type = types.number;
            default = 60.0;
            description = ''
              Refresh rate of the display in hertz. Common values are 60.0, 75.0, or 144.0.
            '';
          };
          dimensions = {
            width = lib.mkOption {
              type = types.number;
              description = ''
                Width of the display output in pixels.
              '';
            };
            height = lib.mkOption {
              type = types.number;
              description = ''
                Height of the display output in pixels.
              '';
            };
          };
          scale = lib.mkOption {
            type = types.number;
            default = 1.0;
            description = ''
              Scale factor for the display output. Useful for HiDPI setups.
              For example, 2.0 scales content to twice the normal size.
            '';
          };
          monitorSpec = {
            vendor = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Optional vendor name of the display (e.g., "LG", "Samsung").
                May be used for matching or diagnostics.
              '';
            };
            product = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Optional product name of the display (e.g., "DELL U2723QE").
              '';
            };
            serial = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Optional serial number of the display device.
                Useful for distinguishing between identical models.
              '';
            };
          };
        };
      }
    );
    default = { };
    description = ''
      Configuration for display outputs used by Wayland compositors or X11 display managers.
      Each attribute key represents an output name (like "HDMI-A-1" or "DP-1"), mapping
      to settings for resolution, position, refresh rate, and more.
    '';
  };
}
