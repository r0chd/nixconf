{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
