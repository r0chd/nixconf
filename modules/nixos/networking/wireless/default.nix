{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.networking.wireless;
in
{
  imports = [
    ./iwd.nix
    ./networkmanager.nix
  ];

  config = lib.mkIf (cfg.iwd.enable || cfg.networkmanager.enable) {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        wirelesstools
        traceroute
        inetutils
        bind
        wget
        ;
    };
  };
}
