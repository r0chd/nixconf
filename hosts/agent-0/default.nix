{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    k3s = { };
  };

  system = {
    bootloader.legacy = true;
    fileSystem = "zfs";
  };

  networking.hostId = "a62446e5";

  services = {
    impermanence.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
