{ config, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  boot = {
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    blacklistedKernelModules = [
      "b43"
      "bcma"
    ];
  };

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
    activationScripts.rfkillUnblockWifi = {
      text = ''
        rfkill unblock wifi
      '';
      deps = [ ];
    };
  };

  networking = {
    wireless.iwd.enable = true;
    interfaces.eth0.useDHCP = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = [ pkgs.helix ];
  };

  services = {
    tailscale.enable = true;
    impermanence.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
