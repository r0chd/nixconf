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

  config =
    lib.mkIf
      (
        cfg.steam.enable
        || cfg.heroic.enable
        || cfg.lutris.enable
        || cfg.minecraft.enable
        || cfg.bottles.enable
      )
      {
        programs = {
          gamescope.enable = true;
          gamemode = {
            enable = true;
            settings = {
              gpu = {
                apply_gpu_optimizations = "accept-responsibility";
                gpu_device = 0;
              };
            };
          };
        };
      };
}
