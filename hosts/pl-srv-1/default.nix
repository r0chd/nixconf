{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system = {
    bootloader.legacy = true;
    fileSystem = "zfs";
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
