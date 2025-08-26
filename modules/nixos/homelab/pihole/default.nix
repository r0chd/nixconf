{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.pihole;
  inherit (lib) types;
in
{
  options.homelab.pihole = {
    passwordFile = lib.mkOption { type = types.path; };
    dns = lib.mkOption { type = types.str; };
    domain = lib.mkOption { type = types.str; };
    webLoadBalancerIP = lib.mkOption { type = types.str; };
    dnsLoadBalancerIP = lib.mkOption { type = types.str; };
    adlists = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    replicas = lib.mkOption {
      type = types.int;
      default = 1;
    };
  };

  config.services.k3s = lib.mkIf config.homelab.enable {
    autoDeployCharts.pihole = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://mojo2600.github.io/pihole-kubernetes";
        chart = "pihole";
        version = "2.18.0";
        chartHash = "sha256-IPXWgsxtZ5E3ybsMjMuyWduMIH3HLwDHch8alipRNNo=";
      };
      targetNamespace = "pihole-system";
      createNamespace = true;
      values = {
        DNS1 = [ cfg.dns ];
        persistentVolumeClaim = {
          enabled = true;
          storageClass = "openebs-hostpath";
        };
        ingress = {
          enabled = true;
          annotations = {
            "nginx.ingress.kubernetes.io/ssl-redirect" = "true";
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP";
          };
          hosts = [ cfg.domain ];
          tls = [
            {
              secretName = "pihole-tls-secret";
              hosts = [ cfg.domain ];
            }
          ];
        };
        serviceWeb = {
          loadBalancerIP = cfg.webLoadBalancerIP;
          annotations."metallb.universe.tf/allow-shared-ip" = "pihole-svc";
          type = "LoadBalancer";
        };
        serviceDns = {
          loadBalancerIP = cfg.dnsLoadBalancerIP;
          annotations."metallb.universe.tf/allow-shared-ip" = "pihole-svc";
          type = "LoadBalancer";
        };
        replicaCount = cfg.replicas;
        admin = {
          enabled = true;
          existingSecret = "pihole-password";
          passwordKey = "password";
        };
        inherit (cfg) adlists;
      };
    };
    secrets = [
      {
        name = "pihole-password";
        namespace = "pihole-system";
        data = {
          password = cfg.passwordFile;
        };
      }
    ];
  };
}
