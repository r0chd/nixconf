{
  lib,
  config,
  profile,
  pkgs,
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
    services.hyprlauncher = {
      enable = true;
    };

    wayland.windowManager = {
      hyprland.settings.bind = [
        "$mainMod, S, exec, ${config.services.hyprlauncher.package}/bin/hyprlauncher"
      ];

      sway.config.keybindings = {
        "Mod1+S" =
          "exec ${pkgs.uwsm}/bin/uwsm app ${config.services.hyprlauncher.package}/bin/hyprlauncher";
      };
    };

    programs.niri.settings.binds."Alt+S".action.spawn = [
      "${pkgs.uwsm}/bin/uwsm"
      "app"
      "${config.services.hyprlauncher.package}/bin/hyprlauncher"
    ];
  };
}
