{ lib, config, ... }:
let
  cfg = config.services.udev;
in
{
  options.services.udev = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    extraRules = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."udev/rules.d/99-local.rules".text = cfg.extraRules;

    systemd.services.udev-reload-rules = {
      description = "Reload udev rules";
      wantedBy = [ "system-manager.target" ];
      before = [ "system-manager.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        echo "Reloading udev rules..."
        udevadm control --reload-rules
      '';
      restartIfChanged = true;
    };
  };
}
