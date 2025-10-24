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
  imports = [ ./iwd ];

  config = lib.mkIf cfg.iwd.enable {
    environment.systemPackages = builtins.attrValues {
      inherit (pkgs)
        wirelesstools
        traceroute
        inetutils
        bind
        ;
    };
  };
}
