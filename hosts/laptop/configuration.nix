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
      "nvidia-settings"
    ];

  networking = {
    wireless.iwd.enable = true;
    hosts = {
      "100.123.153.127" = [ "rpi" ];
      "100.65.94.104" = [ "laptop-lenovo" ];
      "u0_a249@192.168.50.240:8022" = [ "xiaomi" ];
    };
  };

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "catppuccin-mocha";
  };

  programs = {
    thunderbird.enable = true;
    adb.enable = true;
    nix-index.enable = true;
    sway.enable = true;
    niri.enable = true;
    wshowkeys.enable = true;
  };

  users.users.unixpariah.extraGroups = [
    "adbuser"
    "docker"
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  virtualisation = {
    enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
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

  sops.secrets.tailscale = { };

  services = {
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
      extraDaemonFlags = [
        "--state"
        "mem:."
      ];
    };
    impermanence.enable = true;

  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      helix
      kdePackages.oxygen-sounds
      deepin.deepin-sound-theme
      papirus-icon-theme
    ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
