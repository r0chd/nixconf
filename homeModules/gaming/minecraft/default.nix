{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gaming.minecraft;
in
{
  options.gaming.minecraft.enable = lib.mkEnableOption "Enable minecraft";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.prismlauncher ];

    impermanence.persist.directories = [
      ".local/share/PrismLauncher"
    ];
  };
}
