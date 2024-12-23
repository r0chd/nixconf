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
  ];

  home.packages =
    with pkgs;
    lib.mkIf (cfg.steam.enable || cfg.heroic.enable || cfg.lutris.enable || cfg.minecraft.enable) [
      protonup
      gamescope
      mangohud
      (writeShellScriptBin "steamos-session-select" ''
        steam -shutdown
      '')
    ];
}
