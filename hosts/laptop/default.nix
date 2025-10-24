{
  config,
  pkgs,
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
    "pihole/password" = { };
    "grafana/username" = { };
    "grafana/password" = { };

    "garage/rpc-secret" = { };
    "garage/admin-token" = { };
    "garage/metrics-token" = { };

    nixos-anywhere = {
      owner = "nixos-anywhere";
      group = "nixos-anywhere";
      mode = "0400";
    };
  };

  programs.nixos-anywhere.sshKeyFile = config.sops.secrets.nixos-anywhere.path;

  documentation.enable = true;

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    thunderbird.enable = true;
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

  networking = {
    hostId = "499673df";
    wireless = {
      iwd.enable = true;
      mainInterface = "wlan0";
    };
  };

  system = {
    fileSystem = "zfs";
  };

  security = {
    yubikey = {
      enable = true;
      rootAuth = true;
      id = "31888351";
      actions.unplug.enable = true;
    };
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

    impermanence.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        helix
        cosmic-icons
        ;
    };
  };

  homelab = {
    enable = true;
    pihole = {
      enable = true;
      domain = "pihole.example.com";
      dns = "192.168.0.1";
      passwordFile = config.sops.secrets."pihole/password".path;
      adlists = [ "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" ];
      webLoadBalancerIP = "192.168.0.102";
      dnsLoadBalancerIP = "192.168.0.103";
    };
    garage = {
      enable = true;
      rpcSecretFile = config.sops.secrets."garage/rpc-secret".path;
      adminTokenFile = config.sops.secrets."garage/admin-token".path;
      metricsTokenFile = config.sops.secrets."garage/metrics-token".path;
    };
    metallb.addresses = [ "192.168.0.100-192.168.0.150" ];
    grafana = {
      domain = "grafana.example.com";
      usernameFile = config.sops.secrets."grafana/username".path;
      passwordFile = config.sops.secrets."grafana/password".path;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  #nixpkgs.hostPlatform.gcc = {
  #  arch = "skylake";
  #  tune = "skylake";
  #};
}
