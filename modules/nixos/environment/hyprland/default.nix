{
  config,
  lib,
  pkgs,
  profile,
  ...
}:
let
  cfg = config.programs.hyprland;
in
{
  programs.hyprland.enable = lib.mkDefault (profile == "desktop");

  # Make plugins available system-wide without loading them
  environment.systemPackages = lib.mkIf cfg.enable [ pkgs.hyprscroller ];

  # Expose plugin path via environment variable for easy loading
  environment.sessionVariables = lib.mkIf cfg.enable {
    HYPRLAND_PLUGINS = "${pkgs.hyprscroller}/lib/libhyprscroller.so";
  };
}
