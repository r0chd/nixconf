{
  pkgs,
  config,
  lib,
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
      "steam"
      "steam-unwrapped"
    ];

  sops.secrets = {
    nixos-anywhere = {
      owner = "nixos-anywhere";
      group = "nixos-anywhere";
      mode = "0400";
    };
  };

  programs.nixos-anywhere.sshKeyFile = config.sops.secrets.nixos-anywhere.path;

  services = {
    sccache.enable = true;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  users.groups.wl-clicker = { };
  users.users.unixpariah.extraGroups = [
    "podman"
    "wl-clicker"
  ];

  documentation.enable = true;

  boot.tmp.useTmpfs = true;

  gaming = {
    steam.enable = true;
    minecraft.enable = true;
  };
  networking.firewall.allowedTCPPorts = [ 25565 ];

  system = {
    bootloader = {
      silent = true;
    };
    fileSystem = "zfs";
  };

  hardware = {
    power-management.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        #quickwit
        helix
        kubectl
        cosmic-icons
        ;
    };
  };

  security = {
    yubikey = {
      enable = true;
      rootAuth = true;
      id = "31888351";
      actions = {
        unplug.enable = true;
        plug.enable = true;
      };
    };
    root.timeout = 0;
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  networking = {
    wireless = {
      iwd.enable = true;
    };
    hostId = "6add04c2";
  };

  services = {
    gc = {
      enable = true;
      interval = 3;
    };
    impermanence.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
