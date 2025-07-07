{
  config,
  lib,
  profile,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.environment.idle;
  locker = "${pkgs.hyprlock}/bin/hyprlock";
in
{
  imports = [ inputs.moxidle.homeManagerModules.default ];

  options.environment.idle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = profile == "desktop";
    };
  };

  config.services.moxidle = {
    inherit (cfg) enable;
    settings = {
      general = {
        lock_cmd = "pidof ${locker} || ${locker}";
        unlock_cmd = "pkill -USR1 hyprlock";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
        ignore_audio_inhibit = false;
      };
      listeners = [
        {
          conditions = [
            "on_battery"
            { battery_level = "critical"; }
            { battery_state = "discharging"; }
          ];
          timeout = 300;
          on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
        {
          conditions = [ "on_ac" ];
          timeout = 300;
          on_timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          conditions = [ "on_ac" ];
          timeout = 900;
          on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
