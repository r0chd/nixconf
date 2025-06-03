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
    "wireless/SaltoraUp" = { };
    "wireless/Saltora" = { };
  };

  boot.supportedFilesystems = [ "nfs" ];
  services = {
    rpcbind.enable = true;
    fprintd.enable = true;
    fprintd.tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  system = {
    bootloader = {
      variant = "systemd-boot";
      silent = true;
    };
    fileSystem = "zfs";
    gc = {
      enable = true;
      interval = 3;
    };
  };

  hardware = {
    power-management.enable = true;
    audio.enable = true;
    bluetooth.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      nfs-utils
      helix
      kubectl
      cosmic-icons
    ];
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    sway.enable = false;
    hyprland.enable = false;

    nix-index.enable = true;

    gamescope.enable = true;
    gamemode = {
      enable = true;
      settings = {
        gpu = {
          apply_gpu_optimizations = "accept-responsibility";
          gpu_device = 0;
        };
      };
    };
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
      };
    };

    hostId = "6add04c2";
    firewall.allowedTCPPorts = [
      80
      443
      6443
      8443
      3000
      30080
    ];
  };

  systemd = {
    tmpfiles.rules = [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];
    mounts = [
      {
        what = "/dev/zvol/zdata/longhorn-ext4";
        type = "ext4";
        where = "/var/lib/longhorn";
        wantedBy = [ "kubernetes.target" ];
        requiredBy = [ "kubernetes.target" ];
        options = "noatime,discard";
      }
    ];
  };
  virtualisation.docker.logDriver = "json-file";

  services = {
    openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    impermanence.enable = true;
    #tailscale.authKeyFile = config.sops.secrets.tailscale.path;
    #k3s = {
    #enable = true;
    #tokenFile = config.sops.secrets.k3s.path;
    #clusterInit = true;
    #extraFlags = [
    #"--disable traefik"
    #"--disable servicelb"
    #"--write-kubeconfig-mode \"0644\""
    #"--disable local-storage"
    #"--kube-controller-manager-arg bind-address=0.0.0.0"
    #"--kube-proxy-arg metrics-bind-address=0.0.0.0"
    #"--kube-scheduler-arg bind-address=0.0.0.0"
    #"--etcd-expose-metrics true"
    #"--kubelet-arg containerd=/run/k3s/containerd/containerd.sock"
    #];
    #};
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
