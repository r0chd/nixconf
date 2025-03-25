{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    #./disko.nix
    ./hardware-configuration.nix
  ];

  hardware.rpi.enable = true;

  system = {
    fileSystem = "ext4";
    bootloader = {
      variant = "none";
      silent = true;
    };
    gc = {
      enable = true;
      interval = 3;
    };
  };

  virtualisation.docker.enable = true;
  users.users.unixpariah.extraGroups = [ "docker" ];

  environment = {
    persist.directories = [
      "/var/log"
      "/var/lib/nixos"
    ];
    variables.EDITOR = "nvim";
    systemPackages = [ inputs.nixvim.packages.${pkgs.system}.default ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
