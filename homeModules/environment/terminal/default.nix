{
  lib,
  config,
  pkgs,
  system_type,
  ...
}:
let
  cfg = config.environment.terminal;
  programExe = "${lib.getExe (pkgs.${cfg.program})}";
in
{
  imports = [
    ./kitty
    ./foot
    ./ghostty
  ];

  options.environment.terminal = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = system_type == "desktop";
    };
    program = lib.mkOption {
      type = lib.types.enum [
        "kitty"
        "foot"
        "ghostty"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager = {
      hyprland.settings = {
        exec-once = [ "uwsm app ${programExe}" ];
        bind = [ "$mainMod+Shift, RETURN, exec, uwsm app ${programExe}" ];
      };

      sway.config = {
        startup = [ { command = "sway workspace 1; uwsm app ${programExe}"; } ];
        keybindings = {
          "Mod1+Shift+Return" = "exec uwsm app ${programExe}";
        };
      };
    };
    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = [
            "uwsm"
            "app"
            "${programExe}"
          ];
        }
      ];

      binds."Alt+Shift+Return".action.spawn = [
        "uwsm"
        "app"
        "${programExe}"
      ];
    };
  };
}
