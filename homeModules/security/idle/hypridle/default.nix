{ lib, config, ... }:
let cfg = config.screenIdle;
in {
  services.hypridle =
    lib.mkIf (cfg.idle.enable && cfg.idle.program == "hypridle") {
      enable = true;
      settings = {
        general = { ignore_dbus_inhibit = true; };
        listener = [
          {
            timeout = 300;
            on-timeout = "${cfg.lockscreen.program}";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
}
