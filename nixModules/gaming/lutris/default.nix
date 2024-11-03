{ pkgs, config, lib, ... }:

let cfg = config.gaming;
in {
  config = lib.mkIf cfg.steam.enable {
    environment.systemPackages = with pkgs;
      [ (lutris.override { extraPkgs = pkgs: [ ]; }) ];
  };
}

