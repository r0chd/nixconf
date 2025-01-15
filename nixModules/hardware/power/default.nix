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
    systemd.services.powersave = {
      enable = true;

      description = "Apply power saving tweaks";
      wantedBy = [ "multi-user.target" ];

      script = ''
        echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
        echo 1 > /sys/module/snd_hda_intel/parameters/power_save
        echo 0 > /proc/sys/kernel/nmi_watchdog

        for i in /sys/bus/pci/devices/*; do
          echo auto > "$i/power/control"
        done
      '';
    };

    hardware.openrazer.batteryNotifier = {
      enable = true;
      percentage = 20;
    };

    services = {
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          START_CHARGE_THRESH_BAT0 = cfg.thresh.start;
          STOP_CHARGE_THRESH_BAT0 = cfg.thresh.stop;
        };
      };
      thermald.enable = true;
    };

    powerManagement.enable = true;
  };
}
