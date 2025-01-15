{
  lib,
  config,
  pkgs,
  std,
  ...
}:
let
  cfg = config.environment.notifications;
in
{
  options.environment.notifications = {
    enable = lib.mkEnableOption "Enable notifications";
    program = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ libnotify ];
    wayland.windowManager = {
      hyprland.settings.exec-once = [ "uwsm app ${std.nameToPackage pkgs cfg.program}" ];

      sway.config.startup = [
        { command = "uwsm app ${std.nameToPackage pkgs cfg.program}"; }
      ];
    };
    programs.niri.settings.spawn-at-startup = [
      {
        command = [
          "uwsm"
          "app"
          "${std.nameToPackage pkgs cfg.program}"
        ];
      }
    ];
  };
}
