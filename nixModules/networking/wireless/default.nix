{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.networking.wireless.iwd;
in
{
  imports = [ ./iwd ];

  config = lib.mkIf cfg.enable {
    networking = {
      firewall.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wirelesstools
      traceroute
      inetutils
      bind
    ];
  };
}
