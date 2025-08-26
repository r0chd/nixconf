{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homelab.grafana;
  inherit (lib) types;
in
{
  options.homelab.grafana = {
    enable = lib.mkEnableOption "grafana";
    domain = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
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

  config.services.k3s = {
    secrets = lib.mkIf (config.homelab.enable) [
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
          enabled = true;
          annotations = {
            "nginx.ingress.kubernetes.io/rewrite-target" = "/";
            # "nginx.ingress.kubernetes.io/ssl-redirect" = "true";  # Commented out for no TLS
          };
          hosts = [ cfg.domain ];
          # tls = [
          #   {
          #     secretName = "ssl-cert";
          #     hosts = [ "grafana.your-domain.com" ];
          #   }
          # ];
        };
        admin = {
          existingSecret = "grafana-admin-credentials";
          userKey = "username";
          passwordKey = "password";
        };
        serviceMonitor.enabled = true;
      };
    };
  };
}
