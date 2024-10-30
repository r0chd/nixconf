{ config, std, lib, username, ... }: {
  options.lockscreen = {
    enable = lib.mkEnableOption "Enable lockscreen";
    program = lib.mkOption { type = lib.types.enum [ "hyprlock" ]; };
  };

  imports = [
    (import ./hyprlock {
      inherit std lib username;
      conf = config;
    })
  ];
}
