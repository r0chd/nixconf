{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.monitoring.grafana;
  inherit (lib) types;
in
{
  options.homelab.monitoring.grafana = {
    enable = lib.mkOption {
      type = types.bool;
      default = config.homelab.enable;
    };
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "grafana.${config.homelab.domain}" else null;
      description = "Hostname for grafana ingress (defaults to grafana.<domain> if domain is set)";
    };
    usernameFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    passwordFile = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      secrets = [
        {
          name = "grafana-admin-credentials";
          namespace = "monitoring";
          data = {
            password = cfg.passwordFile;
            username = cfg.usernameFile;
          };
        }
      ];

      autoDeployCharts.grafana = {
        package = pkgs.lib.downloadHelmChart {
          repo = "https://grafana.github.io/helm-charts";
          chart = "grafana";
          version = "9.4.4";
          chartHash = "sha256-y5SlZLj2tkgtH+oV4hl7DOEtTzCFvTiw1kOwUpSqYuI=";
        };
        targetNamespace = "monitoring";
        values = {
          service.port = 3000;
          ingress = {
            enabled = cfg.ingressHost != null;
            ingressClassName = "nginx";
            annotations = {
              "nginx.ingress.kubernetes.io/rewrite-target" = "/";
              "cert-manager.io/cluster-issuer" = "letsencrypt";
            };
            hosts = lib.optional (cfg.ingressHost != null) cfg.ingressHost;
            tls = lib.optional (cfg.ingressHost != null) {
              hosts = [ cfg.ingressHost ];
              secretName = "grafana-tls";
            };
          };
          admin = {
            existingSecret = "grafana-admin-credentials";
            userKey = "username";
            passwordKey = "password";
          };
          serviceMonitor.enabled = true;
          resources = {
            limits = {
              cpu = "500m";
              memory = "512Mi";
            };
            requests = {
              cpu = "100m";
              memory = "128Mi";
            };
          };
        };
      };
    };
  };
}
