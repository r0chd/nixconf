{ lib, ... }:
{
  imports = [
    ./hypridle
    ./swayidle
  ];

  options.environment.screenIdle.idle = {
    enable = lib.mkEnableOption "Idle daemon";
    variant = lib.mkOption {
      type = lib.types.enum [
        "hypridle"
        "swayidle"
      ];
    };
    timeout = {
      lock = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
      suspend = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
    };
  };
}
