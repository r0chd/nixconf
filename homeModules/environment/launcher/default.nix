{
  lib,
  config,
  pkgs,
  std,
  ...
}:
let
  cfg = config.environment.launcher;
in
{
  options.environment.launcher = {
    enable = lib.mkEnableOption "Enable launcher";
    program = lib.mkOption { type = lib.types.enum [ "fuzzel" ]; };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager = {
      hyprland.settings.bind = [ "$mainMod, S, exec, ${std.nameToPackage pkgs cfg.program}" ];

      sway.config.keybindings = {
        "Mod1+S" = "exec uwsm app ${std.nameToPackage pkgs cfg.program}";
      };
    };
    programs.niri.settings.binds."Alt+S".action.spawn = [
      "uwsm"
      "app"
      "${std.nameToPackage pkgs cfg.program}"
    ];
  };
}
