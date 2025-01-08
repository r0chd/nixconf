{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.environment.screenIdle;
in
{
  config = lib.mkIf (cfg.idle.enable && cfg.idle.variant == "swayidle") {
    home.packages = [ pkgs.swayaudioidleinhibit ];
    services.swayidle = {
      enable = true;
      timeouts =
        [
        ]
        ++ lib.optional (cfg.idle.timeout.lock != null) {
          timeout = cfg.idle.timeout.lock;
          command = "${pkgs.${cfg.lockscreen.program}}/bin/${cfg.lockscreen.program}";
        }
        ++ lib.optional (cfg.idle.timeout.suspend != null) {
          timeout = cfg.idle.timeout.suspend;
          command = "systemctl suspend";
        }
        ++ lib.optional config.environment.notifications.enable {
          timeout = cfg.idle.timeout.lock - 5;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking screen in 5 seconds...' -t 5000";
        };
    };
  };
}
