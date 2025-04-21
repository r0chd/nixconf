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
    k3s = {
      enable = true;
      role = "server";
      token = "6I14EXRueEmPhuN0";
      extraFlags = builtins.toString ([
        "--write-kubeconfig-mode \"0644\""
        "--cluster-init"
        "--disable servicelb"
        "--disable traefik"
        "--disable localstorage"
      ]);
    };

    impermanence.enable = true;
    tailscale = {
      #authKeyFile = config.sops.secrets.tailscale.path;
      #extraDaemonFlags = [
      #"--state"
      #"mem:."
      #];
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
