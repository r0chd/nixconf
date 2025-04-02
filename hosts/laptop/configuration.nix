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
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "nvidia-x11"
      "nvidia-settings"
      "cuda_cudart"
      "cuda_cccl"
      "libcublas"
      "cuda_nvcc"
    ];

  nixpkgs.config.cudaSupport = true;

  networking = {
    wireless.iwd.enable = true;
    hosts = {
      "100.123.153.127" = [ "rpi" ];
      "100.65.94.104" = [ "laptop-lenovo" ];
    };
  };

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    nix-index.enable = true;
    sway.enable = true;
    niri.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  virtualisation = {
    enable = true;
    virt-manager.enable = true;
  };

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

  sops.secrets.wireguard-key = { };

  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
    tailscale.enable = true;
    impermanence.enable = true;
    protonvpn = {
      enable = false;
      interface = {
        privateKeyFile = config.sops.secrets.wireguard-key.path;
        ip = "10.2.0.2/32";
      };
      endpoint = {
        publicKey = "dldo97jXTUvjEQqaAx3pHy4lKFSxcmZYDCGFvvDOIGQ=";
        ip = "149.34.244.179";
      };
    };
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = [ pkgs.helix ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
