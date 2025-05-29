{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system = {
    bootloader.variant = "systemd-boot";
    fileSystem = "btrfs";
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
