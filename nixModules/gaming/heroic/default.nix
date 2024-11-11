{ pkgs, config, lib, ... }:
let cfg = config.gaming;
in {
  config = lib.mkIf cfg.heroic.enable {
    environment.systemPackages = with pkgs; [ heroic ];

    impermanence.persist-home.directories = [ ".config/heroic" "Games/Heroic" ];
  };
}
