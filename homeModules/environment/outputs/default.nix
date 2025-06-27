{ lib, ... }:
with lib;
with lib.types;
{
  imports = [
    ./mutter
    ./niri
    ./hyprland
    ./sway
  ];

  options.environment.outputs = mkOption {
    type = attrsOf (submodule {
      options = {
        primary = mkOption {
          type = bool;
          default = false;
          description = ''
            Whether this output should be treated as the primary display.
            Used to set focus, taskbars, or default workspace placement.
          '';
        };
        position = {
          x = mkOption {
            type = number;
            default = 0;
            description = ''
              X-coordinate of the top-left corner of the display output
              in the global layout space.
            '';
          };
          y = mkOption {
            type = number;
            default = 0;
            description = ''
              Y-coordinate of the top-left corner of the display output
              in the global layout space.
            '';
          };
        };
        refresh = mkOption {
          type = number;
          default = 60.0;
          description = ''
            Refresh rate of the display in hertz. Common values are 60.0, 75.0, or 144.0.
          '';
        };
        dimensions = {
          width = mkOption {
            type = number;
            description = ''
              Width of the display output in pixels.
            '';
          };
          height = mkOption {
            type = number;
            description = ''
              Height of the display output in pixels.
            '';
          };
        };
        scale = mkOption {
          type = number;
          default = 1.0;
          description = ''
            Scale factor for the display output. Useful for HiDPI setups.
            For example, 2.0 scales content to twice the normal size.
          '';
        };
        monitorSpec = {
          vendor = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Optional vendor name of the display (e.g., "LG", "Samsung").
              May be used for matching or diagnostics.
            '';
          };
          product = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Optional product name of the display (e.g., "DELL U2723QE").
            '';
          };
          serial = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              Optional serial number of the display device.
              Useful for distinguishing between identical models.
            '';
          };
        };
      };
    });
    default = { };
    description = ''
      Configuration for display outputs used by Wayland compositors or X11 display managers.
      Each attribute key represents an output name (like "HDMI-A-1" or "DP-1"), mapping
      to settings for resolution, position, refresh rate, and more.
    '';
  };
}
