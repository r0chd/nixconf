{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  system = {
    fileSystem = "btrfs";
    bootloader = {
      variant = "systemd-boot";
      silent = true;
    };
    gc = {
      enable = true;
      interval = 3;
    };
  };

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [ inputs.nixvim.packages.${system}.default ];
  };

  services = {
    tailscale.enable = true;
    impermanence.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
