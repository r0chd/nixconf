{ lib, config, pkgs, ... }: {
  config = lib.mkIf config.gaming.minecraft.enable {
    environment.systemPackages = with pkgs; [ prismlauncher ];

    impermanence.persist-home.directories =
      lib.mkIf config.impermanence.enable [ ".local/share/PrismLauncher" ];
  };
}
