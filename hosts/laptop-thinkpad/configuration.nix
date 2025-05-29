{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    tailscale = { };
  };

  services.tailscale.authKeyFile = config.sops.secrets.tailscale.path;

  system = {
    bootloader = {
      variant = "grub";
      legacy = true;
    };
    fileSystem = "btrfs";
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
