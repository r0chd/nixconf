{ lib, profile, ... }:
{
  imports = [ ./greetd ];

  options.system.displayManager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = profile == "desktop";
    };
  };
}
