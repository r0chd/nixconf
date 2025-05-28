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

    environment.persist.directories = [ "/var/lib/iwd" ];
  };
}
