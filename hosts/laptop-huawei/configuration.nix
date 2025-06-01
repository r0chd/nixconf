{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  #sops.secrets = {
  #k3s = { };
  #tailscale = { };
  #};

  system = {
    bootloader = {
      variant = "systemd-boot";
      legacy = false;
    };
    fileSystem = "zfs";
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  networking = {
    hostId = "6add04c2";
    wireless.iwd.enable = true;
    firewall.allowedTCPPorts = [
      80
      443
      6443
      8443
      3000
      30080
    ];
  };

  #services = {
  #tailscale.authKeyFile = config.sops.secrets.tailscale.path;
  #k3s = {
  #enable = true;
  #tokenFile = config.sops.secrets.k3s.path;
  #clusterInit = true;
  #extraFlags = [
  #"--disable traefik"
  #"--disable servicelb"
  #];
  #};
  #};

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
