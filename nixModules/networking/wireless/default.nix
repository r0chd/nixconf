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

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

    environment.systemPackages = with pkgs; [
      wirelesstools
      traceroute
      inetutils
    ];
  };
}
