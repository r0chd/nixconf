{ config, lib, ... }:
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
    ./gamescope
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
        programs.gamemode = {
          enable = true;
          settings.gpu = {
            apply_gpu_optimizations = "accept-responsibility";
            gpu_device = 0;
          };
        };
      };
}
