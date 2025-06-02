{ config, pkgs, ... }:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  sops.secrets = {
    tailscale = { };
  };

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

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.unixpariah.extraGroups = [ "podman" ];

  networking = {
    wireless.iwd.enable = true;
    interfaces.eth0.useDHCP = true;
    firewall.allowedTCPPorts = [
      80
      443
      6443
    ];
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = [ pkgs.helix ];
  };

  services = {
    impermanence.enable = true;
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
