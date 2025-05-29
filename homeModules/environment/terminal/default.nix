{
  lib,
  config,
  pkgs,
  system_type,
  ...
}:
let
  cfg = config.environment.terminal;
  programBin = "${lib.getBin (pkgs.${cfg.program})}/${cfg.program}";
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
        exec-once = [ "uwsm app ${programBin}" ];
        bind = [ "$mainMod+Shift, RETURN, exec, uwsm app ${programBin}" ];
      };

      sway.config = {
        startup = [ { command = "sway workspace 1; uwsm app ${programBin}"; } ];
        keybindings = {
          "Mod1+Shift+Return" = "exec uwsm app ${programBin}";
        };
      };
    };
    programs.niri.settings = {
      spawn-at-startup = [
        {
          command = [
            "uwsm"
            "app"
            "${programBin}"
          ];
        }
      ];

      binds."Alt+Shift+Return".action.spawn = [
        "uwsm"
        "app"
        "${programBin}"
      ];
    };
  };
}
