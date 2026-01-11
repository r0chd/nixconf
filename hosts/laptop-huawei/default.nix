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
      "dragonflydb"
    ];

  sops.secrets = {
    proton = { };
  };

  services = {
    dragonflydb = {
      enable = true;
      port = 63790;
    };
    protonvpn = {
      enable = true;
      interface = {
        privateKeyFile = config.sops.secrets.proton.path;
      };
      endpoint = {
        publicKey = "U6Jj/WjvFjeGa4ub7Sbqv7082Ex6l4AoBtsGTnw4glY=";
        ip = "149.34.244.129";
      };
    };
    #tailscale.enable = true;
    sccache.enable = true;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  users.users.unixpariah.extraGroups = [
    "podman"
  ];

  documentation.enable = true;

  boot.tmp.useTmpfs = true;

  gaming = {
    steam.enable = true;
    minecraft.enable = true;
    heroic.enable = true;
  };

  system = {
    bootloader = {
      silent = true;
    };
  };

  hardware = {
    power-management.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues {
      inherit (pkgs)
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
  };

  stylix = {
    enable = true;
    theme = "catppuccin-mocha";
  };

  networking = {
    wireless = {
      networkmanager.enable = true;
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
