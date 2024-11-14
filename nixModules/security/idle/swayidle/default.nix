{ lib, config, username, ... }:
let cfg = config.screenIdle;
in {
  config = lib.mkIf (cfg.idle.enable && cfg.idle.program == "swayidle") {
    home-manager.users."${username}".services.swayidle = {
      enable = true;
      events = [{
        event = "lock";
        command = "${cfg.lockscreen.program}";
      }];
    };
  };
}
