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
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  system = {
    fileSystem = "btrfs";
    bootloader = {
      variant = "none";
      silent = true;
    };
    gc = {
      enable = true;
      interval = 3;
    };
  };

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

  network.wireless.enable = true;

  environment = {
    persist.directories = [
      "/var/log"
      "/var/lib/nixos"
    ];
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [ inputs.nixvim.packages.${system}.default ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.hostPlatform = "aarch64-linux";
}
