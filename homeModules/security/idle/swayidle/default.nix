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
    services.swayidle = {
      enable = true;
      timeouts =
        [
          {
            timeout = cfg.idle.timeout.lock;
            command = "${pkgs.${cfg.lockscreen.program}}/bin/${cfg.lockscreen.program}";
          }
        ]
        ++ (lib.optional (config.environment.notifications.enable) {
          timeout = cfg.idle.timeout.lock - 5;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking screen in 5 seconds...' -t 5000";
        });
    };
  };
}
