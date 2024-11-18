{ config, lib, ... }:
{
  options.lsd.enable = lib.mkEnableOption "Enable lsd";

  config = lib.mkIf config.lsd.enable {
    programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  };
}
