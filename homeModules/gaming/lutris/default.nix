{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.gaming;
in
{
  config = lib.mkIf cfg.lutris.enable {
    home.packages = with pkgs; [ (lutris.override { extraPkgs = pkgs: [ ]; }) ];

    impermanence.persist.directories = [
      ".local/share/lutris"
      "Games/Lutris"
    ];
  };
}
