{ config, lib, ... }: {
  options.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf config.bat.enable {
    home.shellAliases.cat = "bat";
    programs.bat.enable = true;
  };
}
