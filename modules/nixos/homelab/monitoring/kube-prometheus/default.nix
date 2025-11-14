{ lib, config, ... }:
let
  cfg = config.homelab.monitoring;
  inherit (lib) types;
in
{
  imports = [ ./dashboards ];

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
      username = lib.mkOption {
        type = types.str;
      };
      password = lib.mkOption {
        type = types.str;
      };
    };
    alertmanager = {
      enable = lib.mkEnableOption "alertmanager";
      discordWebhookUrl = lib.mkOption {
        type = types.str;
      };
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default = if config.homelab.domain != null then "alertmanager.${config.homelab.domain}" else null;
        description = "Hostname for alertmanager ingress (defaults to alertmanager.<domain> if domain is set)";
      };
    };
    thanos = {
      enable = lib.mkEnableOption "thanos";
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default = if config.homelab.domain != null then "thanos.${config.homelab.domain}" else null;
        description = "Hostname for thanos ingress (defaults to thanos.<domain> if domain is set)";
      };
      bucket = lib.mkOption {
        type = types.str;
      };
      access_key = lib.mkOption {
        type = types.str;
      };
      secret_key = lib.mkOption {
        type = types.str;
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
        # TODO: figure out how to allow prometheus to discover these services.
        # disable monitoring for these, i believe since they are not
        # deployed as a pod prometheus cannot discover them?
        kubeControllerManager.enable = false;
        kubeScheduler.enable = false;
        kubeProxy.enable = false;
        defaultRules.rules = {
          kubeControllerManager = false;
          kubeSchedulerAlerting = false;
          kubeSchedulerRecording = false;
          kubeProxy = false;
        };

        alertmanager = {
          enabled = cfg.alertmanager.enable;
          config = {
            receivers = [
              { name = "null"; }
              {
                name = "default";
                discord_configs = [
                  {
                    apiURL = {
                      name = "alertmanager-config-secrets";
                      key = "DISCORD_WEBHOOK_URL";
                    };
                  }
                ];
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
              group_by = [
                "alertname"
                "cluster"
              ];
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
          ingress =
            if cfg.alertmanager.ingressHost != null then
              {
                enabled = true;
                ingressClassName = "nginx";
                annotations = {
                  "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                  "cert-manager.io/cluster-issuer" = "letsencrypt";
                };
                hosts = [ cfg.alertmanager.ingressHost ];
                paths = [ "/" ];
                pathType = "Prefix";
                tls = [
                  {
                    secretName = "alertmanager-tls";
                    hosts = [ cfg.alertmanager.ingressHost ];
                  }
                ];
              }
            else
              { };
        };

        grafana = {
          enabled = cfg.grafana.enable;

          plugins = (
            if config.homelab.monitoring.quickwit.enable then
              [
                "quickwit-quickwit-datasource 0.4.5"
              ]
            else
              [ ]
          );

          additionalDataSources = builtins.concatLists [
            (
              if cfg.thanos.enable then
                [
                  {
                    name = "thanos";
                    type = "prometheus";
                    access = "proxy";
                    orgID = 1;
                    url = "http://thanos-query.monitoring.svc:9090";
                    version = 1;
                    editable = false;
                  }
                ]
              else
                [ ]
            )

            (
              if config.homelab.monitoring.quickwit.enable then
                [
                  {
                    name = "quickwit";
                    type = "quickwit-quickwit-datasource";
                    url = "http://quickwit-control-plane.monitoring.svc.cluster.local:7280/api/v1";
                    uid = "quickwit";
                    jsonData = {
                      index = "logs";
                      logMessageField = "body.message.text";
                      logLevelField = "severity";
                    };
                  }
                ]
              else
                [ ]
            )
          ];

          admin = {
            existingSecret = "grafana-admin-credentials";
            userKey = "username";
            passwordKey = "password";
          };
          initChownData.enabled = false;
          service.port = 3000;
          ingress =
            if cfg.grafana.ingressHost != null then
              {
                enabled = true;
                ingressClassName = "nginx";
                annotations = {
                  "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                  "cert-manager.io/cluster-issuer" = "letsencrypt";
                };
                hosts = [ cfg.grafana.ingressHost ];
                paths = [ "/" ];
                pathType = "Prefix";
                tls = [
                  {
                    secretName = "grafana-tls";
                    hosts = [ cfg.grafana.ingressHost ];
                  }
                ];
              }
            else
              { };
        };
        prometheus-node-exporter.prometheusSpec.scrapeInterval = "10s";
        prometheus = {
          thanosService = {
            enabled = cfg.thanos.enable;
          };

          thanosServiceMonitor = {
            enabled = cfg.thanos.enable;
          };

          ingress =
            if cfg.prometheus.ingressHost != null then
              {
                enabled = true;
                ingressClassName = "nginx";
                annotations = {
                  "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                  "cert-manager.io/cluster-issuer" = "letsencrypt";
                };
                hosts = [ cfg.prometheus.ingressHost ];
                paths = [ "/" ];
                pathType = "Prefix";
                tls = [
                  {
                    secretName = "prometheus-tls";
                    hosts = [ cfg.prometheus.ingressHost ];
                  }
                ];
              }
            else
              { };

          prometheusSpec = {
            podMonitorNamespaceSelector.matchLabels = { };
            podMonitorSelectorNilUsesHelmValues = false;
            serviceMonitorNamespaceSelector.matchLabels = { };
            serviceMonitorSelectorNilUsesHelmValues = false;
          };
        };
      };
    };

    secrets = (
      lib.optional (cfg.grafana.enable) {
        metadata = {
          name = "grafana-admin-credentials";
          namespace = "monitoring";
        };
        stringData = {
          password = cfg.grafana.password;
          username = cfg.grafana.username;
        };
      }
      ++ lib.optional (cfg.alertmanager.enable) {
        metadata = {
          name = "alertmanager-config-secrets";
          namespace = "monitoring";
        };
        stringData.DISCORD_WEBHOOK_URL = cfg.alertmanager.discordWebhookUrl;
      }
      ++ lib.optional (cfg.thanos.enable) {
        metadata = {
          name = "thanos-objectstorage";
          namespace = "monitoring";
        };
        stringData."thanos.yaml" = ''
          type: s3
          config:
            bucket: ${cfg.thanos.bucket}
            endpoint: "s3.${config.homelab.garage.ingressHost}"
            access_key: ${cfg.thanos.access_key}
            secret_key: ${cfg.thanos.secret_key}
        '';
      }
    );
  };
}
