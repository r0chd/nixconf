{ pkgs, config, lib, ... }:
let cfg = config.gaming;
in {
  config = lib.mkIf cfg.heroic.enable {
    environment.systemPackages = with pkgs; [ heroic ];

    impermanence.persist-home.directories =
      lib.mkIf config.impermanence.enable [ ".config/heroic" "Games/Heroic" ];
  };
}
