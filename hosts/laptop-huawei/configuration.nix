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
    fileSystem = "zfs";
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  networking = {
    hostId = "6add04c2";
    iwd.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
