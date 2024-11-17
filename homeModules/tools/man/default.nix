{ lib, config, username, ... }: {
  options.man.enable = lib.mkEnableOption "Enable man pages";

  config = lib.mkIf config.man.enable {
    home-manager.users."${username}".programs.man.enable = true;
    documentation.dev.enable = true;
  };
}
