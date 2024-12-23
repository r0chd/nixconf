{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.lutris;
in
{
  options.gaming.lutris.enable = lib.mkEnableOption "Enable lutris";

  config = lib.mkIf cfg.enable {
    home.packages = [ (pkgs.lutris.override { extraPkgs = pkgs: [ ]; }) ];

    impermanence.persist.directories = [
      ".local/share/lutris"
      "Games/Lutris"
    ];
  };
}
