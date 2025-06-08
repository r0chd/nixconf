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

  networking = {
    wireless.iwd = {
      enable = true;
      networks = {
        SaltoraUp.psk = config.sops.secrets."wireless/SaltoraUp".path;
        Saltora.psk = config.sops.secrets."wireless/Saltora".path;
      };
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
  };

  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [ "test" ];
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        #...
        #type database DBuser origin-address auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
      initialScript = pkgs.writeText "init" ''
        CREATE TABLE projects (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            stars INTEGER NOT NULL,
            url TEXT NOT NULL,
            homepage TEXT
        );

        CREATE TABLE project_languages (
            project_id INTEGER NOT NULL,
            language TEXT NOT NULL,
            usage INTEGER NOT NULL,
            FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
        );

        CREATE TABLE stats (
            id INTEGER PRIMARY KEY DEFAULT 1,
            name TEXT NOT NULL,
            bio TEXT,
            avatar_url TEXT NOT NULL,
            company TEXT,
            public_repos INTEGER NOT NULL,
            followers INTEGER NOT NULL,
            following INTEGER NOT NULL,
            location TEXT NOT NULL,
            hireable BOOLEAN NOT NULL
        );

        CREATE TABLE education (
          id SERIAL PRIMARY KEY,
        );
      '';
    };

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
