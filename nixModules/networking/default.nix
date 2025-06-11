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
    systemd = {
      services.systemd-networkd-wait-online.enable = lib.mkForce false;
      network = {
        enable = true;
        networks = {
          "50-dhcp" = {
            matchConfig.Name = "en*";
            networkConfig.DHCP = "yes";
            linkConfig.RequiredForOnline = "no";
          };
        };
      };
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
