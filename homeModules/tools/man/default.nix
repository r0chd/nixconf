{ lib, config, ... }: {
  options.man.enable = lib.mkEnableOption "Enable man pages";

  config = lib.mkIf config.man.enable { programs.man.enable = true; };
}
