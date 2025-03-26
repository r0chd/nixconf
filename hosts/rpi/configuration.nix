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
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    inputs.raspberry-pi-nix.nixosModules.sd-image
  ];

  raspberry-pi-nix = {
    board = "bcm2712";
    uboot.enable = false;
    libcamera-overlay.enable = false;
  };

  hardware.raspberry-pi.config = {
    pi5.dt-overlays.vc4-kms-v3d-pi5 = {
      enable = true;
      params = { };
    };
    all.base-dt-params.krnbt = {
      enable = true;
      value = "on";
    };
  };

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
