{ lib, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    primary_node_token = { };
  };

  homelab = {
    enable = true;
    nodeType = "connecting";
    connecting = {
      primaryNodeIp = "https://10.0.0.3:6443";
      tokenFile = config.sops.secrets.primary_node_token.path;
    };
  };

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  networking = {
    hostId = "24da4482";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
}
