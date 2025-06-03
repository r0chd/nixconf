{ lib, system_type, ... }:
{
  imports = [ ./greetd ];

  options.system.displayManager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = (system_type == "desktop");
    };
  };
}
