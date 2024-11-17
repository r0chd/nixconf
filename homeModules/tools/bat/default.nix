{ config, lib, username, ... }: {
  options.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf config.bat.enable {
    environment.shellAliases.cat = "bat";
    home-manager.users."${username}".programs.bat.enable = true;
  };
}
