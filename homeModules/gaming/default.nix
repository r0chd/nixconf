{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming;
in
{
  imports = [
    ./steam
    ./heroic
    ./lutris
    ./minecraft
    ./bottles
  ];

  home.packages =
    with pkgs;
    lib.mkIf
      (
        cfg.steam.enable
        || cfg.heroic.enable
        || cfg.lutris.enable
        || cfg.minecraft.enable
        || cfg.bottles.enable
      )
      [
        protonup
        gamescope
        mangohud
      ];
}
