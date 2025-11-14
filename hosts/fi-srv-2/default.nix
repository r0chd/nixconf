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
    enable = false;
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
    hostId = "71626f6e";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
}
