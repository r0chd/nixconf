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
  };

  services.tailscale.enable = lib.mkForce false;

  boot.loader = {
    limine.enable = lib.mkForce false;
    grub.enable = true;
  };

  homelab = {
    enable = true;
    metallb.addresses = [ "192.168.0.100-192.168.0.150" ];
    system = {
      reloader.enable = true;
      pihole = {
        domain = "pihole.example.com";
        dns = "192.168.0.1";
        passwordFile = config.sops.secrets."pihole/password".path;
        adlists = [ "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" ];
        webLoadBalancerIP = "192.168.0.102";
        dnsLoadBalancerIP = "192.168.0.103";
      };
    };

    garage = {
      ingressHost = "example.com";
      rpcSecretFile = config.sops.secrets."garage/rpc-secret".path;
      adminTokenFile = config.sops.secrets."garage/admin-token".path;
      metricsTokenFile = config.sops.secrets."garage/metrics-token".path;
    };

    monitoring = {
      prometheus.domain = "prometheus.example.com";
      grafana = {
        domain = "grafana.example.com";
        usernameFile = config.sops.secrets."grafana/username".path;
        passwordFile = config.sops.secrets."grafana/password".path;
      };
      kube-web = {
        enable = true;
        ingressHost = "kube-web.example.com";
      };
      kube-ops = {
        enable = true;
        ingressHost = "kube-ops.example.com";
      };
    };
  };

  networking.hostId = "36bfcfc1";

  system.fileSystem = "zfs";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
}
