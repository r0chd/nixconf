{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  boot.loader.limine.enable = lib.mkForce false;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
