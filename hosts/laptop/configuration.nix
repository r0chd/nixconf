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
    deploy-rs = {
      owner = "deploy-rs";
      group = "wheel";
      mode = "0440";
    };
    "wireless/SaltoraUp" = { };
    "wireless/Saltora" = { };
  };

  networking.wireless.iwd = {
    enable = true;
    networks = {
      SaltoraUp.psk = config.sops.secrets."wireless/SaltoraUp".path;
      Saltora.psk = config.sops.secrets."wireless/Saltora".path;
    };
  };

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    deploy-rs.sshKeyFile = config.sops.secrets.deploy-rs.path;
    sway.enable = false;
    hyprland.enable = false;

    thunderbird.enable = true;
    nix-index.enable = true;
    wshowkeys.enable = true;
  };

  gaming = {
    steam.enable = true;
    lutris.enable = true;
    heroic.enable = true;
    bottles.enable = true;
    minecraft.enable = true;
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
