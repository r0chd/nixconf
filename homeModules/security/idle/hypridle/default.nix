{
  lib,
  config,
  pkgs,
  std,
  ...
}:
let
  cfg = config.environment.screenIdle;
in
{
  services.hypridle = lib.mkIf (cfg.idle.enable && cfg.idle.variant == "hypridle") {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${std.nameToPackage pkgs cfg.lockscreen.program}";
        ignore_dbus_inhibit = true;
      };
      listener =
        [
        ]
        ++ lib.optional (cfg.idle.timeout.lock != null) {
          timeout = cfg.idle.timeout.lock;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        ++ lib.optional (cfg.idle.timeout.suspend != null) {
          timeout = cfg.idle.timeout.suspend;
          on-timeout = "systemctl suspend";
        }
        ++ lib.optional config.environment.notifications.enable {
          timeout = cfg.idle.timeout.lock - 5;
          on-timeout = "${pkgs.libnotify}/bin/notify-send 'Locking screen in 5 seconds...' -t 5000";
        };
    };
  };
}
