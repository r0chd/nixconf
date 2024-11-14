{ pkgs, config, lib, ... }:

let cfg = config.gaming;
in {
  config = lib.mkIf cfg.steam.enable {
    environment.systemPackages = with pkgs;
      [ (lutris.override { extraPkgs = pkgs: [ ]; }) ];

    impermanence.persist-home.directories =
      [ ".local/share/lutris" "Games/Lutris" ];
  };
}

