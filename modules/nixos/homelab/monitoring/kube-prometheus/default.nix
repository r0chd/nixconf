{ lib, config, ... }:
let
  cfg = config.homelab.monitoring;
  inherit (lib) types;
in
{
  options.homelab.monitoring = {
    prometheus = {
      enable = lib.mkEnableOption "prometheus";
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default = if config.homelab.domain != null then "prometheus.${config.homelab.domain}" else null;
        description = "Hostname for prometheus ingress (defaults to prometheus.<domain> if domain is set)";
      };
    };
    grafana = {
      enable = lib.mkEnableOption "grafana";
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default = if config.homelab.domain != null then "grafana.${config.homelab.domain}" else null;
        description = "Hostname for grafana ingress (defaults to grafana.<domain> if domain is set)";
      };
      usernameFile = lib.mkOption {
        type = types.nullOr types.str;
      };
      passwordFile = lib.mkOption {
        type = types.nullOr types.str;
      };
    };
    alertmanager = {
      enable = lib.mkEnableOption "alertmanager";
      discordWebhookUrlFile = lib.mkOption {
        type = types.str;
      };
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default = if config.homelab.domain != null then "grafana.${config.homelab.domain}" else null;
        description = "Hostname for grafana ingress (defaults to grafana.<domain> if domain is set)";
      };
    };
  };

  config.services.k3s = {
    autoDeployCharts.prometheus-stack = lib.mkIf cfg.prometheus.enable {
      name = "kube-prometheus-stack";
      repo = "https://prometheus-community.github.io/helm-charts";
      version = "79.2.1";
      hash = "sha256-rUZcfcB+O7hrr2swEARXFujN7VvfC0IkaaAeJTi0mN0=";
      targetNamespace = "monitoring";
      values = {
        alertmanager = lib.mkIf cfg.alertmanager.enable {
          alertmanagerSpec.secrets = [ "alertmanager-config-secrets" ];
          config = {
            receivers = [
              { name = "null"; }
              {
                name = "default";
                discord_configs = [
                  {
                    webhook_url = "\${DISCORD_WEBHOOK_URL}";
                    content = "<@307952129958477824>";
                  }
                ];

                # email_configs = [
                #   {
                #     to = "kurumi-alerts@danielraybone.com";
                #     send_resolved = true;
                #     html = true;
                #   }
                # ];
              }
            ];
            global = {
              resolve_timeout = "5m";
            };
            inhibit_rules = [
              {
                source_matchers = [ "severity = critical" ];
                target_matchers = [ "severity =~ warning|info" ];
                equal = [
                  "namespace"
                  "alertname"
                ];
              }
              {
                source_matchers = [ "severity = warning" ];
                target_matchers = [ "severity = info" ];
                equal = [
                  "namespace"
                  "alertname"
                ];
              }
              {
                source_matchers = [ "alertname = InfoInhibitor" ];
                target_matchers = [ "severity = info" ];
                equal = [ "namespace" ];
              }
              { target_matchers = [ "alertname = InfoInhibitor" ]; }
            ];
            route = {
              group_by = [ "job" ];
              group_wait = "30s";
              group_interval = "5m";
              repeat_interval = "1h";
              receiver = "default";
              routes = [
                {
                  receiver = "null";
                  matchers = [ "alertname = \"Watchdog\"" ];
                }
              ];
            };

            templates = [ "/etc/alertmanager/config/*.tmpl" ];
          };
          ingress = {
            enabled = cfg.alertmanager.ingressHost != null;
            ingressClassName = "nginx";
            annotations = {
              "nginx.ingress.kubernetes.io/rewrite-target" = "/";
              "cert-manager.io/cluster-issuer" = "letsencrypt";
            };
            hosts = lib.optional (cfg.alertmanager.ingressHost != null) cfg.alertmanager.ingressHost;
            tls = lib.optional (cfg.alertmanager.ingressHost != null) {
              hosts = [ cfg.alertmanager.ingressHost ];
              secretName = "alertmanager-tls";
            };
          };
        };

        grafana = {
          enabled = cfg.grafana.enable;
          admin = {
            existingSecret = "grafana-admin-credentials";
            userKey = "username";
            passwordKey = "password";
          };
          initChownData.enabled = false;
          service.port = 3000;
          ingress = {
            enabled = cfg.grafana.ingressHost != null;
            ingressClassName = "nginx";
            annotations = {
              "nginx.ingress.kubernetes.io/rewrite-target" = "/";
              "cert-manager.io/cluster-issuer" = "letsencrypt";
            };
            hosts = lib.optional (cfg.grafana.ingressHost != null) cfg.grafana.ingressHost;
            tls = lib.optional (cfg.grafana.ingressHost != null) {
              hosts = [ cfg.grafana.ingressHost ];
              secretName = "grafana-tls";
            };
          };
        };
        prometheus-node-exporter = {
          prometheusSpec = {
            scrapeInterval = "10s";
          };
        };
        prometheus = {
          ingress = {
            enabled = cfg.prometheus.ingressHost != null;
            ingressClassName = "nginx";
            annotations = {
              "nginx.ingress.kubernetes.io/rewrite-target" = "/";
              "cert-manager.io/cluster-issuer" = "letsencrypt";
            };
            hosts = lib.optional (cfg.prometheus.ingressHost != null) cfg.prometheus.ingressHost;
            tls = lib.optional (cfg.prometheus.ingressHost != null) {
              hosts = [ cfg.prometheus.ingressHost ];
              secretName = "prometheus-tls";
            };
          };
          prometheusSpec = {
            podMonitorNamespaceSelector.matchLabels = { };
            podMonitorSelectorNilUsesHelmValues = false;
            serviceMonitorNamespaceSelector.matchLabels = { };
            serviceMonitorSelectorNilUsesHelmValues = false;
          };
        };
      };
    };

    secrets =
      (lib.optional (cfg.grafana.enable) {
        name = "grafana-admin-credentials";
        namespace = "monitoring";
        data = {
          password = cfg.grafana.passwordFile;
          username = cfg.grafana.usernameFile;
        };
      })
      ++ (lib.optional (cfg.alertmanager.enable) {
        name = "alertmanager-config-secrets";
        namespace = "monitoring";
        data = {
          DISCORD_WEBHOOK_URL = cfg.alertmanager.discordWebhookUrlFile;
        };
      });
  };
}
