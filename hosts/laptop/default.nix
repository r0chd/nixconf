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
      group = "deploy-rs";
      mode = "0440";
    };

    #"grafana/username" = { };
    #"grafana/password" = { };

    #github-api = { };

    #"pihole/password" = { };

    #"immich-postgres-user/DB_USERNAME" = { };
    #"immich-postgres-user/DB_DATABASE_NAME" = { };
    #"immich-postgres-user/DB_PASSWORD" = { };
    #"immich-postgres-user/username" = { };
    #"immich-postgres-user/password" = { };

    #"atuin/DB_USERNAME" = { };
    #"atuin/DB_PASSWORD" = { };
    #"atuin/DB_URI" = { };

    #YUBI = { };
  };

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    ladybird.enable = true;
    deploy-rs.sshKeyFile = config.sops.secrets.deploy-rs.path;
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
    gamescope.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.wireless.mainInterface = "wlan0";

  system = {
    fileSystem = "btrfs";
    bootloader = {
      variant = "systemd-boot";
      silent = true;
    };
    ydotool.enable = true;
  };

  security = {
    yubikey = {
      enable = true;
      rootAuth = true;
      id = "31888351";
      actions.unplug.enable = true;
    };
    root.timeout = 0;
  };

  hardware = {
    power-management.enable = true;
  };

  services = {
    gc = {
      enable = true;
      interval = 3;
    };
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
      clusterInit = true;
      #secrets = [
      #  {
      #    name = "grafana-admin-credentials";
      #    namespace = "monitoring";
      #    data = {
      #      admin-user = config.sops.secrets."grafana/username".path;
      #      admin-password = config.sops.secrets."grafana/password".path;
      #    };
      #  }
      #  {
      #    name = "github-api";
      #    namespace = "portfolio";
      #    data.github_api = config.sops.secrets.github-api.path;
      #  }
      #  {
      #    name = "pihole-password";
      #    namespace = "pihole-system";
      #    data.password = config.sops.secrets."pihole/password".path;
      #  }
      #  {
      #    name = "immich-postgres-user";
      #    namespace = "immich";
      #    data = {
      #      DB_USERNAME = config.sops.secrets."immich-postgres-user/DB_USERNAME".path;
      #      DB_DATABASE_NAME = config.sops.secrets."immich-postgres-user/DB_DATABASE_NAME".path;
      #      DB_PASSWORD = config.sops.secrets."immich-postgres-user/DB_PASSWORD".path;
      #      username = config.sops.secrets."immich-postgres-user/username".path;
      #      password = config.sops.secrets."immich-postgres-user/password".path;
      #    };
      #  }
      #  #{
      #  #  name = "yubisecret";
      #  #  namespace = "vaultwarden";
      #  #data.YUBI = config.sops.secrets.YUBI.path;
      #  #}
      #  #{
      #  #  name = "atuin-secrets";
      #  #  namespace = "atuin";
      #  #  data = {
      #  #    ATUIN_DB_USERNAME = config.sops.secrets."atuin/DB_USERNAME".path;
      #  #    ATUIN_DB_PASSWORD = config.sops.secrets."atuin/DB_PASSWORD".path;
      #  #    ATUIN_DB_URI = config.sops.secrets."atuin/DB_URI".path;
      #  #  };
      #  #}
      #];
      extraFlags = [
        "--disable traefik"
        "--disable servicelb"
        "--write-kubeconfig-mode \"0644\""
        "--disable local-storage"
        "--kube-controller-manager-arg bind-address=0.0.0.0"
        "--kube-proxy-arg metrics-bind-address=0.0.0.0"
        "--kube-scheduler-arg bind-address=0.0.0.0"
        "--etcd-expose-metrics true"
        "--kubelet-arg containerd=/run/k3s/containerd/containerd.sock"
      ];
    };

    tailscale.authKeyFile = config.sops.secrets.tailscale.path;
    impermanence.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues { inherit (pkgs) helix kubectl cosmic-icons; };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
