{ lib, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    "pihole/password" = { };

    "garage/rpc-secret" = { };
    "garage/admin-token" = { };
    "garage/metrics-token" = { };

    "grafana/username" = { };
    "grafana/password" = { };

    "atuin/backup/access_key_id" = { };
    "atuin/backup/secret_access_key" = { };

    "thanos-objectstorage" = { };
  };

  services.tailscale.enable = lib.mkForce false;

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  homelab = {
    enable = true;
    domain = "r0chd.pl";
    metallb.addresses = [
      "157.180.30.62/32"
      "172.31.1.100-172.31.1.150"
    ];
    ingress-nginx.hostNetwork = true;
    system = {
      reloader.enable = true;
      pihole = {
        dns = "172.31.1.1";
        passwordFile = config.sops.secrets."pihole/password".path;
        adlists = [ "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" ];
        webLoadBalancerIP = "172.31.1.102";
        dnsLoadBalancerIP = "172.31.1.103";
      };
    };

    garage = {
      rpcSecretFile = config.sops.secrets."garage/rpc-secret".path;
      adminTokenFile = config.sops.secrets."garage/admin-token".path;
      metricsTokenFile = config.sops.secrets."garage/metrics-token".path;
    };

    moxwiki.enable = true;

    kube-resource-report.enable = true;

    atuin = {
      enable = true;
      db = {
        storageSize = "5Gi";
        walStorageSize = "2Gi";
        backup = {
          enable = true;
          accessKeyIdFile = config.sops.secrets."atuin/backup/access_key_id".path;
          secretAccessKeyFile = config.sops.secrets."atuin/backup/secret_access_key".path;
        };
      };
    };

    vault.enable = true;

    monitoring = {
      thanos = {
        enable = true;
        thanosObjectStorageFile = config.sops.secrets."thanos-objectstorage".path;
      };
      grafana = {
        usernameFile = config.sops.secrets."grafana/username".path;
        passwordFile = config.sops.secrets."grafana/password".path;
      };
      kube-web.enable = true;
      kube-ops.enable = true;
    };
  };

  networking = {
    hostId = "36bfcfc1";
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  system.fileSystem = "zfs";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
}
