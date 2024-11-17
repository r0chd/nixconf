{ username, lib, config, ... }: {
  options.btop.enable = lib.mkEnableOption "btop";

  config = lib.mkIf config.btop.enable {
    home-manager.users."${username}".programs.btop = {
      enable = true;
      settings = { vim_keys = true; };
    };
  };
}
