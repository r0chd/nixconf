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

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.users.unixpariah.extraGroups = [ "docker" ];

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
    "wireless/T-Mobile_5G_HomeOffice_2.4GHz" = { };
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
    wireless.iwd = {
      enable = true;
      networks = {
        SaltoraUp.psk = config.sops.secrets."wireless/SaltoraUp".path;
        Saltora.psk = config.sops.secrets."wireless/Saltora".path;
        "=542d4d6f62696c655f35475f486f6d654f66666963655f322e3447487a".psk =
          config.sops.secrets."wireless/T-Mobile_5G_HomeOffice_2.4GHz".path;
      };
    };

    hostId = "6add04c2";
  };

  services = {
    gc = {
      enable = true;
      interval = 3;
    };
    impermanence.enable = true;
    tailscale.authKeyFile = config.sops.secrets.tailscale.path;

    k3s = {
      enable = true;
      tokenFile = config.sops.secrets.k3s.path;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
