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
    ];

  programs.nix-index.enable = true;

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nix-wallpaper-nineish-catppuccin-mocha.png";
      sha256 = "ce562a4a27794352f9b14ac072f47eeda3768c89a2ba847d832801464f31f56a";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
  };

  virtualisation = {
    #podman = {
    #  enable = true;
    #  dockerCompat = true;
    #};
    enable = true;
    waydroid.enable = true;
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
    impermanence = {
      enable = true;
      persist = {
        directories = [
          "/var/log"
          "/var/lib/nixos"
        ];
        files = [ ];
      };
    };
    gc = {
      enable = true;
      interval = 3;
    };
  };

  security = {
    yubikey = {
      enable = true;
      rootAuth = true;
      unplug.enable = true;
    };
    root.timeout = 0;
  };

  hardware = {
    power-management.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
  };

  network.wireless.enable = true;

  zramSwap.enable = true;

  services = {
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
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      inputs.nixvim.packages.${system}.default
    ];
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
