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
    enable = lib.mkEnableOption "pihole";
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

  config.services.k3s = lib.mkIf (config.homelab.enable && cfg.enable) {
    autoDeployCharts = {
      pihole = {
        package = pkgs.lib.downloadHelmChart {
          repo = "https://mojo2600.github.io/pihole-kubernetes";
          chart = "pihole";
          version = "2.18.0";
          chartHash = "sha256-IPXWgsxtZ5E3ybsMjMuyWduMIH3HLwDHch8alipRNNo=";
        };
        targetNamespace = "system";
        createNamespace = true;
        values = {
          DNS1 = [ cfg.dns ];
          persistentVolumeClaim = {
            enabled = true;
            storageClass = "local-path";
          };
          ingress = {
            enabled = true;
            annotations = {
              "nginx.ingress.kubernetes.io/ssl-redirect" = "false";
              "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP";
            };
            hosts = [ cfg.domain ];
            #tls = [
            #  {
            #    secretName = "pihole-tls-secret";
            #    hosts = [ cfg.domain ];
            #  }
            #];
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
            existingSecret = "pihole";
            passwordKey = "password";
          };
          inherit (cfg) adlists;
        };
      };

      externaldns-pihole = {
        name = "externaldns-pihole";
        targetNamespace = "system";
        repo = "oci://registry-1.docker.io/bitnamicharts/external-dns";
        version = "9.0.0";
        hash = "sha256-uanyYjrtTuErABr9qNn/z36QP3HV3Ew2h6oJvpB+FwA=";
        values = {
          global.security.allowInsecureImages = true;
          image = {
            registry = "registry.k8s.io";
            repository = "external-dns/external-dns";
            tag = "v0.14.0";
          };
          provider = "pihole";
          policy = "upsert-only";
          txtOwnerId = "homelab";
          pihole.server = "http://pihole-web.system.svc.cluster.local";
          extraEnvVars = [
            {
              name = "EXTERNAL_DNS_PIHOLE_PASSWORD";
              valueFrom.secretKeyRef = {
                name = "pihole";
                key = "password";
              };
            }
          ];
          serviceAccount = {
            create = true;
            name = "external-dns";
          };
          ingressClassFilters = [ "ingress-nginx" ];
        };
      };
    };
    secrets = [
      {
        name = "pihole";
        namespace = "system";
        data = {
          password = cfg.passwordFile;
        };
      }
    ];
  };
}
