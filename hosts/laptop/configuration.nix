{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "nvidia-x11"
      "steam"
      "steam-unwrapped"
    ];

  sops.secrets = {
    tailscale = { };
    k3s = { };
  };

  networking = {
    wireless.iwd.enable = true;
  };

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    sway.enable = false;
    hyprland.enable = false;

    thunderbird.enable = true;
    nix-index.enable = true;
    wshowkeys.enable = true;

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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

  system = {
    fileSystem = "btrfs";
    bootloader = {
      variant = "systemd-boot";
      silent = true;
    };
    ydotool.enable = true;
    gc = {
      enable = true;
      interval = 3;
    };
  };

  security = {
    yubikey = {
      enable = true;
      rootAuth = true;
      id = "31888351";
      unplug.enable = true;
    };
    root.timeout = 0;
  };

  hardware = {
    power-management.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
  };

  zramSwap.enable = true;

  services = {
    k3s = {
      enable = true;
      tokenFile = config.sops.secrets.k3s.path;
    };
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
    impermanence.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      helix
      kubectl
      cosmic-icons
    ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
