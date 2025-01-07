{ lib, ... }:
{
  imports = [ ./greetd ];

  options.system.displayManager = {
    enable = lib.mkEnableOption "Enable display manager";
    variant = lib.mkOption {
      type = lib.types.enum [ "greetd" ];
    };
  };

  config.systemd.services.display-manager = {
    serviceConfig = {
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true; # so we won't need all of this
    };
  };
}
