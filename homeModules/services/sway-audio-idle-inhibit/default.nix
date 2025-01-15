{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.sway-audio-idle-inhibit;
in
{
  options.services.sway-audio-idle-inhibit = {
    enable = lib.mkEnableOption "sway audio idle inhibit";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.sway-audio-idle-inhibit;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.sway-audio-idle-inhibit = {
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "sway-audio-idle-inhibit";
        After = [ "graphical-session.service" ];
      };

      Service = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
