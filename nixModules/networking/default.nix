{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./wireless
    ./ssh
  ];

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
          #DNS = [ "192.168.50.102" ];
          IgnoreCarrierLoss = "3s";
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "true";
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
}
