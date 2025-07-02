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
    systemd.network.networks."50-wireless" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
        DNS = config.networking.nameservers;
        IgnoreCarrierLoss = "3s";
      };
    };

    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      dnsovertls = "false";
    };

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
