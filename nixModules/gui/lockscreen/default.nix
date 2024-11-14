{ lib, ... }: {
  options.screenIdle.lockscreen = {
    enable = lib.mkEnableOption "Enable lockscreen";
    program = lib.mkOption { type = lib.types.enum [ "hyprlock" ]; };
  };

  imports = [ ./hyprlock ];
}
