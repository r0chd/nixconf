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

  nixpkgs.config.allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [ "nvidia-x11" ];

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
    theme = "catppuccin-mocha";
  };

  programs = {
    thunderbird.enable = true;
    nix-index.enable = true;
    sway.enable = true;
    niri.enable = true;
    wshowkeys.enable = true;
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
      variant = "lanzaboote";
      silent = true;
    };
    ydotool.enable = true;
    displayManager = {
      enable = true;
      variant = "greetd";
    };
    gc = {
      enable = true;
      interval = 3;
    };
  };

  security = {
    tpm2.enable = true;
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
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
    impermanence.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      helix
      kubectl
    ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
