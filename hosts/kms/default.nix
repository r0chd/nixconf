{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking = {
    hostId = "662febd7";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  services.tailscale.enable = lib.mkForce false;

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  homelab = {
    enable = true;
    domain = "kms.r0chd.pl";
    #storageClassName = "openebs-zfs-localpv";

    metallb.addresses = [
      "46.62.204.148/32"
      "172.31.1.100-172.31.1.150"
    ];
    system = {
      zfs-localpv.poolname = "zroot";
      reloader.enable = true;
    };

    vault = {
      enable = true;
      proxy.enable = true;
    };
  };

  system.fileSystem = "zfs";

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
}
