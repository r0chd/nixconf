{ lib, ... }:
{
  imports = [ ./greetd ];

  options.system.displayManager = {
    enable = lib.mkEnableOption "Enable display manager";
    variant = lib.mkOption {
      type = lib.types.enum [ "greetd" ];
    };
  };
}
