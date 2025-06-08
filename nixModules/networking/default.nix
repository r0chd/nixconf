{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.networking;
in
{
  imports = [
    ./wireless
    ./ssh
  ];

  options.networking.dns = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = {
    networking.useDHCP = lib.mkForce false;
    systemd.network = {
      enable = true;
      networks = {
        "50-dhcp" = {
          matchConfig.Name = "en*";
          networkConfig.DHCP = "yes";
          linkConfig.RequiredForOnline = "no";
        };

        "50-wireless" = {
          matchConfig.Name = "wlan0";
          networkConfig = {
            DHCP = "yes";
            DNS = cfg.nameservers;
            IgnoreCarrierLoss = "3s";
          };
        };
      };
    };

    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      dnsovertls = "false";
    };

    boot.initrd = {
      network.enable = true;
      systemd = {
        network = config.systemd.network;
        services.systemd-tmpfiles-setup.before = [ "sshd.service" ];
      };
      availableKernelModules = [ "alx" ];
      kernelModules = [
        "vfat"
        "nls_cp437"
        "nls_iso8859-1"
        "usbhid"
        "alx"
      ];
    };
  };
}
