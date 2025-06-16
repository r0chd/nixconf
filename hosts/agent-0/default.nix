{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    k3s = { };
    tailscale = { };
  };

  system = {
    bootloader = {
      variant = "grub";
      legacy = true;
    };
    fileSystem = "zfs";
  };

  networking = {
    hostId = "a62446e5";
    wireless.iwd.enable = true;
  };

  services = {
    k3s = {
      enable = true;
      role = "agent";
      serverAddr = "https://server-0:6443";
      tokenFile = config.sops.secrets.k3s.path;
    };
    impermanence.enable = true;
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
