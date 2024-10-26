{ lib, conf }:
let inherit (conf) username;
in {
  options.nix-index.enable = lib.mkEnableOption "Enable nix-index";

  config = lib.mkIf conf.nix-index.enable {
    home-manager.users."${username}".programs.nix-index.enable = true;
  };
}
