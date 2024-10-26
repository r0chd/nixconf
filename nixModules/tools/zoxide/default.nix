{ conf, lib }: {
  options.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf conf.zoxide.enable {
    home-manager.users."${conf.username}".programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
