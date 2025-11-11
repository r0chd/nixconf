{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.system.pihole;
  inherit (lib) types;
in
{
  imports = [
    ./external-dns-rbac.nix
  ];

  options.homelab.system.pihole = {
    enable = lib.mkEnableOption "pihole";
    passwordFile = lib.mkOption { type = types.path; };
    dns = lib.mkOption { type = types.str; };
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "pihole.${config.homelab.domain}" else null;
      description = "Hostname for pihole ingress (defaults to pihole.<domain> if domain is set)";
    };
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
    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      default = { };
      description = "Optional Kubernetes resource requests/limits.";
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
            storageClass = config.homelab.storageClass;
          };
          ingress = {
            enabled = cfg.ingressHost != null;
            annotations = {
              "nginx.ingress.kubernetes.io/ssl-redirect" = if cfg.ingressHost != null then "true" else "false";
              "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP";
              "cert-manager.io/cluster-issuer" = "letsencrypt";
            };
            hosts = lib.optional (cfg.ingressHost != null) cfg.ingressHost;
            tls = lib.optional (cfg.ingressHost != null) {
              secretName = "pihole-tls";
              hosts = [ cfg.ingressHost ];
            };
            serviceName = "pihole-web";
            servicePort = 80;
          };
          serviceWeb = {
            loadBalancerIP = cfg.webLoadBalancerIP;
            annotations."metallb.universe.tf/allow-shared-ip" = "pihole-svc";
            type = "ClusterIP";
          };
          serviceDns = {
            loadBalancerIP = cfg.dnsLoadBalancerIP;
            annotations."metallb.universe.tf/allow-shared-ip" = "pihole-svc";
            type = "ClusterIP";
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

          inherit (cfg) resources;

          livenessProbe = {
            enabled = true;
            initialDelaySeconds = 30;
            periodSeconds = 30;
            timeoutSeconds = 5;
            failureThreshold = 3;
            successThreshold = 1;
          };

          readinessProbe = {
            enabled = true;
            initialDelaySeconds = 10;
            periodSeconds = 10;
            timeoutSeconds = 5;
            failureThreshold = 3;
            successThreshold = 1;
          };

          logLevel = "info";
          logFormat = "json";
          interval = "2m";

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
            automountServiceAccountToken = true;
          };
          ingressClassFilters = [ "nginx" ];
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
