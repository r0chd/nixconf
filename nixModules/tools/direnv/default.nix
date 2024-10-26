{ conf, lib }:
let inherit (conf) username;
in {
  options.direnv.enable = lib.mkEnableOption "Enable direnv";

  config = lib.mkIf conf.direnv.enable {
    home-manager.users."${username}".programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
