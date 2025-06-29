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
      "libfprint-2-tod1-goodix"
    ];

  sops.secrets = {
    k3s = { };
    tailscale = { };
    deploy-rs = {
      owner = "deploy-rs";
      group = "wheel";
      mode = "0440";
    };
    "wireless/SaltoraUp" = { };
    "wireless/Saltora" = { };
  };

  services = {
    rpcbind.enable = true;
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
  };

  documentation.enable = true;

  system = {
    bootloader = {
      variant = "systemd-boot";
      silent = true;
    };
    fileSystem = "zfs";
  };

  hardware = {
    power-management.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      helix
      kubectl
      cosmic-icons
    ];
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

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    ladybird.enable = true;
    sway.enable = false;
    hyprland.enable = false;

    deploy-rs.sshKeyFile = config.sops.secrets.deploy-rs.path;
    nix-index.enable = true;
  };

  gaming = {
    steam.enable = true;
  };

  networking = {
    extraHosts = ''
      192.168.50.159 t851
    '';
    wireless.iwd = {
      enable = true;
      networks = {
        SaltoraUp.psk = config.sops.secrets."wireless/SaltoraUp".path;
        Saltora.psk = config.sops.secrets."wireless/Saltora".path;
      };
    };

    hostId = "6add04c2";
    firewall.allowedTCPPorts = [
      80
      443
      2049
      6443
      8443
      3000
      30080
    ];
  };

  services = {
    gc = {
      enable = true;
      interval = 3;
    };
    impermanence.enable = true;
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
