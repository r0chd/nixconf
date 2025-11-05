{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.monitoring.prometheus;
  inherit (lib) types;
in
{
  options.homelab.monitoring.prometheus = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "prometheus.${config.homelab.domain}" else null;
      description = "Hostname for prometheus ingress (defaults to prometheus.<domain> if domain is set)";
    };
  };

  config.services.k3s.autoDeployCharts = lib.mkIf cfg.enable {
    prometheus-crds = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://prometheus-community.github.io/helm-charts";
        chart = "prometheus-operator-crds";
        version = "22.0.2";
        chartHash = "sha256-NWeTgwFukR8/MuC0VnlrMFRmaWpFxtrIt5ewWMueaig=";
      };
      targetNamespace = "monitoring";
      createNamespace = true;
    };

    prometheus = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://prometheus-community.github.io/helm-charts";
        chart = "prometheus";
        version = "27.32.0";
        chartHash = "sha256-7picRoOCgfUUr+oBHCwPzOEd4GUj3q2frBZHlbcWYT0=";
      };
      targetNamespace = "monitoring";
      values = {
        server = {
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
              secretName = "prometheus-tls";
            };
          };
          resources = {
            limits = {
              cpu = "2";
              memory = "4Gi";
            };
            requests = {
              cpu = "200m";
              memory = "1Gi";
            };
          };
        };
      };
    };
  };
}
