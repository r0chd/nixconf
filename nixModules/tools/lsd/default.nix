{ conf, lib }:
let inherit (conf) username;
in {
  options.lsd.enable = lib.mkEnableOption "Enable lsd";

  config = lib.mkIf conf.lsd.enable {
    home-manager.users."${username}".programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  };
}
