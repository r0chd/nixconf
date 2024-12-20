{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  system = {
    fileSystem = "btrfs";
    bootloader = "lanzaboote";
    virtualisation = {
      virt-manager.enable = true;
      distrobox.enable = true;
    };
    ydotool.enable = true;
    impermanence = {
      enable = true;
      persist = {
        directories = [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
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
      unplug = {
        enable = true;
        action = "${pkgs.hyprlock}/bin/hyprlock";
      };
    };
    root = {
      auth = {
        passwordless = true;
        rootPw = true;
      };
      timeout = 0;
    };
  };

  hardware = {
    power-management = {
      enable = true;
      thresh = {
        start = 40;
        stop = 80;
      };
    };
    audio.enable = true;
    bluetooth.enable = true;
  };

  network = {
    ssh.enable = true;
    wireless.enable = true;
  };

  zramSwap.enable = true;

  services.protonvpn = {
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

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      obsidian
      mangohud
      nvd
      nix-output-monitor
      just
      inputs.nixvim.packages.${system}.default
    ];
  };

  sops.secrets = {
    "ssh_keys/unixpariah" = {
      owner = "unixpariah";
      path = "/home/unixpariah/.ssh/id_ed25519";
    };
    "ssh_keys/unixpariah-yubikey" = {
      owner = "unixpariah";
      path = "/home/unixpariah/.ssh/id_yubikey";
    };
    wireguard-key = { };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
