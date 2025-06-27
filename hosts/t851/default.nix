{ ... }:
{
  #imports = [ ./hardware-configuration.nix ];

  system = {
    bootloader = {
      variant = "grub";
      legacy = false;
    };
    fileSystem = "ext4";
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
