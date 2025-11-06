{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    # Make plugins available system-wide without loading them
    environment.systemPackages = [ pkgs.hyprscroller ];

    # Expose plugin path via environment variable for easy loading
    environment.sessionVariables = {
      HYPRLAND_PLUGINS = "${pkgs.hyprscroller}/lib/libhyprscroller.so";
    };
  };
}
