{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system = {
    bootloader = {
      variant = "systemd-boot";
      legacy = false;
    };
    fileSystem = "btrfs";
  };

  time.timeZone = "a";
  i18n.defaultLocale = "a";
}
