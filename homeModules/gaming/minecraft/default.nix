{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gaming.minecraft.enable {
    home.packages = with pkgs; [ prismlauncher ];

    impermanence.persist.directories = [ ".local/share/PrismLauncher" ];
  };
}
