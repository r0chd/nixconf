{ lib, config, username, pkgs, ... }:
let cfg = config.screenIdle;
in {
  config = lib.mkIf (cfg.idle.enable && cfg.idle.program == "swayidle") {
    home-manager.users."${username}".services.swayidle = {
      enable = true;
      timeouts = [{
        timeout = cfg.idle.timeout.lock;
        command =
          "${pkgs.${cfg.lockscreen.program}}/bin/${cfg.lockscreen.program}";
      }] ++ (lib.optional (config.notifications.enable) {
        timeout = cfg.idle.timeout.lock - 5;
        command =
          "${pkgs.libnotify}/bin/notify-send 'Locking screen in 5 seconds...' -t 5000";
      });
    };
  };
}
