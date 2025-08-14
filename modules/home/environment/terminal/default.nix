{
  lib,
  config,
  pkgs,
  profile,
  ...
}:
let
  cfg = config.environment.terminal;
  programExe = "${lib.getExe pkgs.${cfg.program}}";
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
      default = profile == "desktop";
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
        exec-once = [ "${pkgs.uwsm}/bin/uwsm app ${programExe}" ];
        bind = [ "$mainMod+Shift, RETURN, exec, ${pkgs.uwsm}/bin/uwsm app ${programExe}" ];
      };

      sway.config = {
        startup = [ { command = "sway workspace 1; ${pkgs.uwsm}/bin/uwsm app ${programExe}"; } ];
        keybindings = {
          "Mod1+Shift+Return" = "exec ${pkgs.uwsm}/bin/uwsm app ${programExe}";
        };
      };
    };
    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = [
            "${pkgs.uwsm}/bin/uwsm"
            "app"
            "${programExe}"
          ];
        }
      ];

      binds."Alt+Shift+Return".action.spawn = [
        "${pkgs.uwsm}/bin/uwsm"
        "app"
        "${programExe}"
      ];
    };
  };
}
