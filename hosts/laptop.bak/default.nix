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
    k3s = { };
    deploy-rs = {
      owner = "deploy-rs";
      group = "deploy-rs";
      mode = "0440";
    };

    "pihole/password" = { };

    "atuin/DB_PASSWORD" = { };
    "atuin/DB_URI" = { };

    #"grafana/username" = { };
    #"grafana/password" = { };

    #github-api = { };

    #"immich-postgres-user/DB_USERNAME" = { };
    #"immich-postgres-user/DB_DATABASE_NAME" = { };
    #"immich-postgres-user/DB_PASSWORD" = { };
    #"immich-postgres-user/username" = { };
    #"immich-postgres-user/password" = { };

    #YUBI = { };
  };

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
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

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    tmp.useTmpfs = true;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.wireless = {
    iwd.enable = true;
    mainInterface = "wlan0";
  };

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
    sccache.enable = true;
    gc = {
      enable = true;
      interval = 3;
    };

    k3s = {
      tokenFile = config.sops.secrets.k3s.path;
      clusterInit = true;
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

    impermanence.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues { inherit (pkgs) helix cosmic-icons; };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
