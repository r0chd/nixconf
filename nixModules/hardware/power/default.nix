{ config, lib, ... }:
let
  cfg = config.hardware.power-management;
in
{
  options.hardware.power-management = {
    enable = lib.mkEnableOption "Enable power management";
    thresh = {
      start = lib.mkOption {
        type = lib.types.int;
        default = 40;
      };
      stop = lib.mkOption {
        type = lib.types.int;
        default = 80;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          START_CHARGE_THRESH_BAT0 = cfg.thresh.start;
          STOP_CHARGE_THRESH_BAT0 = cfg.thresh.stop;
        };
      };
      thermald.enable = true;
    };

    powerManagement.enable = true;
  };
}
