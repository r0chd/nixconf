{ config, lib, username, ... }: {
  options.lsd.enable = lib.mkEnableOption "Enable lsd";

  config = lib.mkIf config.lsd.enable {
    home-manager.users."${username}".programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  };
}
