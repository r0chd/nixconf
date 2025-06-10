{ inputs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    inputs.raspberry-pi-nix.nixosModules.raspberry-pi-5.base
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi-5.display-vc4
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi-5.bluetooth
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi-5.display-rp1
  ];

  system = {
    bootloader.variant = "none";
    fileSystem = "zfs";
  };

  networking.hostId = "6f9ba310";

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
