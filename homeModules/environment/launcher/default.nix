{
  lib,
  config,
  pkgs,
  profile,
  ...
}:
let
  cfg = config.environment.launcher;
in
{
  options.environment.launcher.enable = lib.mkOption {
    type = lib.types.bool;
    default = profile == "desktop";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager = {
      hyprland.settings.bind = [ "$mainMod, S, exec, fuzzel" ];

      sway.config.keybindings = {
        "Mod1+S" = "exec uwsm app fuzzel";
      };
    };

    programs = {
      fuzzel = {
        enable = true;
        settings.main.launch-prefix = "uwsm app -t service --";
      };
      niri.settings.binds."Alt+S".action.spawn = [
        "uwsm"
        "app"
        "fuzzel"
      ];
    };
  };
}
