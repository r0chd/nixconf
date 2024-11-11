{ lib, config, pkgs, ... }: {
  config = lib.mkIf config.gaming.minecraft.enable {
    environment.systemPackages = with pkgs; [ prismlauncher ];

    impermanence.persist-home.directories = [ ".local/share/PrismLauncher" ];
  };
}
