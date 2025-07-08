{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.networking.wireless;
  inherit (lib) types;
in
{
  imports = [ ./iwd ];

  options.networking.wireless.mainInterface = lib.mkOption {
    type = types.nullOr types.str;
    default = null;
  };

  config = lib.mkIf cfg.iwd.enable {
    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      dnsovertls = "false";
    };

    systemd.network.networks."50-wireless" = lib.mkIf (cfg.mainInterface != null) {
      matchConfig.Name = cfg.mainInterface;
      networkConfig = {
        DHCP = "yes";
        DNS = config.networking.nameservers;
        IgnoreCarrierLoss = "3s";
      };
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
