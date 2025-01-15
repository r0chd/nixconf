{ lib, ... }:
{
  options.environment.screenIdle.lockscreen = {
    enable = lib.mkEnableOption "Enable lockscreen";
    program = lib.mkOption { type = lib.types.enum [ "hyprlock" ]; };
  };

  imports = [ ./hyprlock ];
}
