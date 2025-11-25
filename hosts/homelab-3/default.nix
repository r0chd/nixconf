{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    primary_node_token = { };
  };

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  homelab = {
    enable = true;
    nodeType = "connecting";
    metallb.addresses = [
      "95.217.10.128/32"
      "172.31.1.100-172.31.1.150"
    ];
    connecting = {
      primaryNodeIp = "https://10.0.0.2:6443";
      tokenFile = config.sops.secrets.primary_node_token.path;
    };
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";
}
