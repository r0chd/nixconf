{
  config,
  lib,
  profile,
  pkgs,
  ...
}:
let
  cfg = config.environment.idle;
  inherit (lib) types;
in
{
  options.environment.idle = {
    enable = lib.mkOption {
      type = types.bool;
      default = profile == "desktop";
    };
    package = lib.mkPackageOption pkgs "moxidle" { };
    stages = {
      dim = {
        enable = lib.mkOption {
          type = types.bool;
          default = true;
        };
        timeout = lib.mkOption {
          type = types.int;
          default = 150;
        };
      };
      lock = {
        enable = lib.mkOption {
          type = types.bool;
          default = true;
        };
        timeout = lib.mkOption {
          type = types.int;
          default = 300;
        };
      };
      sleep = {
        enable = lib.mkOption {
          type = types.bool;
          default = true;
        };
        timeout = lib.mkOption {
          type = types.int;
          default = 900;
        };
      };
    };
  };
  config = {
    services.moxidle = {
      inherit (cfg) enable;
      inherit (cfg) package;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          unlock_cmd = "pkill -USR1 hyprlock";
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
          ignore_audio_inhibit = false;
        };
        listeners = lib.flatten [
          (lib.optional cfg.stages.dim.enable {
            inherit (cfg.stages.dim) timeout;
            on_timeout = "${pkgs.brightnessctl}/bin/brightnessctl set 5% --save";
            on_resume = "${pkgs.brightnessctl}/bin/brightnessctl --restore";
          })
          (lib.optional cfg.stages.lock.enable {
            conditions = [
              "on_battery"
              { battery_level = "critical"; }
              { battery_state = "discharging"; }
              { usb_unplugged = "1050:0407"; }
            ];
            inherit (cfg.stages.lock) timeout;
            on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
          })
          (lib.optional cfg.stages.lock.enable {
            conditions = [
              "on_ac"
              { usb_unplugged = "1050:0407"; }
            ];
            inherit (cfg.stages.lock) timeout;
            on_timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          })
          (lib.optional cfg.stages.sleep.enable {
            conditions = [
              "on_ac"
              { usb_unplugged = "1050:0407"; }
            ];
            inherit (cfg.stages.sleep) timeout;
            on_timeout = "${pkgs.systemd}/bin/systemctl suspend";
          })
        ];
      };
    };

    nix.settings = lib.mkIf cfg.enable {
      substituters = [ "https://moxidle.cachix.org" ];
      trusted-substituters = [ "https://moxidle.cachix.org" ];
      trusted-public-keys = [ "moxidle.cachix.org-1:ck2KY0PlOsrgMUBfJaYVmcDbyHT2cK6KSvLP09amGUU=" ];
    };
  };
}
