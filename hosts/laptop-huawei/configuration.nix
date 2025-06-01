{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "nvidia-x11"
      "steam"
      "steam-unwrapped"
    ];

  sops.secrets = {
    k3s = { };
    tailscale = { };
  };

  system = {
    bootloader = {
      variant = "systemd-boot";
      legacy = false;
    };
    fileSystem = "zfs";
    gc = {
      enable = true;
      interval = 3;
    };
  };

  hardware = {
    power-management.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      helix
      kubectl
      cosmic-icons
    ];
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    sway.enable = false;
    hyprland.enable = false;

    nix-index.enable = true;

    gamescope.enable = true;
    gamemode = {
      enable = true;
      settings = {
        gpu = {
          apply_gpu_optimizations = "accept-responsibility";
          gpu_device = 0;
        };
      };
    };
    steam = {
      enable = true;
      platformOptimizations.enable = true;
      protontricks.enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };

  networking = {
    hostId = "6add04c2";
    wireless.iwd.enable = true;
    firewall.allowedTCPPorts = [
      80
      443
      6443
      8443
      3000
      30080
    ];
  };

  services = {
    impermanence.enable = false;
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
    k3s = {
      enable = true;
      tokenFile = config.sops.secrets.k3s.path;
      clusterInit = true;
      extraFlags = [
        "--disable traefik"
        "--disable servicelb"
      ];
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
