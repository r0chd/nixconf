{
  lib,
  config,
  pkgs,
  std,
  ...
}:
let
  cfg = config.environment.terminal;
in
{
  options.environment.terminal = {
    enable = lib.mkEnableOption "Enable terminal emulator";
    program = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager = {
      hyprland.settings = {
        exec-once = [ "uwsm app ${std.nameToPackage pkgs cfg.program}" ];
        bind = [ "$mainMod+Shift, RETURN, exec, uwsm app ${std.nameToPackage pkgs cfg.program}" ];
      };

      sway.config = {
        startup = [
          { command = "sway workspace 1; uwsm app ${std.nameToPackage pkgs cfg.program}"; }
        ];
        keybindings = {
          "Mod1+Shift+Return" = "exec uwsm app ${std.nameToPackage pkgs cfg.program}";
        };
      };
    };
    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = [
            "uwsm"
            "app"
            "${std.nameToPackage pkgs cfg.program}"
          ];
        }
      ];

      binds."Alt+Shift+Return".action.spawn = [
        "uwsm"
        "app"
        "${std.nameToPackage pkgs cfg.program}"
      ];
    };
  };
}
