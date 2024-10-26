{ conf, lib }:
let inherit (conf) username;
in {
  options.bat.enable = lib.mkEnableOption "Enable bat";

  config = lib.mkIf conf.bat.enable {
    environment.shellAliases.cat = "bat";
    home-manager.users."${username}".programs.bat = { enable = true; };
  };
}
