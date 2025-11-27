{ lib, config, ... }:
let
  cfg = config.homelab.monitoring;
  inherit (lib) types;
in
{
  imports = [
    ./dashboards
    ./thanos
    ./alerts
  ];

  options.homelab.monitoring = {
    prometheus = {
      enable = lib.mkEnableOption "prometheus";
      gated = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to gate this service behind oauth2-proxy";
      };
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default =
          if config.homelab.domain != null then
            if config.homelab.monitoring.prometheus.gated then
              "prometheus.i.${config.homelab.domain}"
            else
              "prometheus.${config.homelab.domain}"
          else
            null;
        description = "Hostname for prometheus ingress (defaults to prometheus.i.<domain> if gated, prometheus.<domain> otherwise)";
      };
    };
    grafana = {
      enable = lib.mkEnableOption "grafana";
      gated = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to gate this service behind oauth2-proxy";
      };
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default =
          if config.homelab.domain != null then
            if config.homelab.monitoring.grafana.gated then
              "grafana.i.${config.homelab.domain}"
            else
              "grafana.${config.homelab.domain}"
          else
            null;
        description = "Hostname for grafana ingress (defaults to grafana.i.<domain> if gated, grafana.<domain> otherwise)";
      };
      passwordAuth = {
        enable = lib.mkEnableOption "password auth";
        username = lib.mkOption {
          type = types.str;
        };
        password = lib.mkOption {
          type = types.str;
        };
      };
    };
    alertmanager = {
      enable = lib.mkEnableOption "alertmanager";
      discordWebhookUrl = lib.mkOption {
        type = types.str;
      };
      gated = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to gate this service behind oauth2-proxy";
      };
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default =
          if config.homelab.domain != null then
            if config.homelab.monitoring.alertmanager.gated then
              "alertmanager.i.${config.homelab.domain}"
            else
              "alertmanager.${config.homelab.domain}"
          else
            null;
        description = "Hostname for alertmanager ingress (defaults to alertmanager.i.<domain> if gated, alertmanager.<domain> otherwise)";
      };
    };
    thanos = {
      enable = lib.mkEnableOption "thanos";
      gated = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Whether to gate this service behind oauth2-proxy";
      };
      ingressHost = lib.mkOption {
        type = types.nullOr types.str;
        default =
          if config.homelab.domain != null then
            if config.homelab.monitoring.thanos.gated then
              "thanos.i.${config.homelab.domain}"
            else
              "thanos.${config.homelab.domain}"
          else
            null;
        description = "Hostname for thanos ingress (defaults to thanos.i.<domain> if gated, thanos.<domain> otherwise)";
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

      image = lib.mkOption {
        type = types.str;
        default = "quay.io/thanos/thanos:v0.30.2";
        description = "Docker image for thanos components";
      };

      query = {
        replicas = lib.mkOption {
          type = types.int;
          default = 1;
          description = "Number of thanos-query replicas";
        };
      };

      queryFrontend = {
        replicas = lib.mkOption {
          type = types.int;
          default = 1;
          description = "Number of thanos-query-frontend replicas";
        };
      };

      store = {
        replicas = lib.mkOption {
          type = types.int;
          default = 1;
          description = "Number of thanos-store replicas";
        };
        storageSize = lib.mkOption {
          type = types.str;
          default = "10Gi";
          description = "Storage size for thanos-store data volume";
        };
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
        kubeControllerManager.enabled = false;
        kubeScheduler.enabled = false;
        kubeProxy.enabled = false;

        alertmanager =
          if cfg.alertmanager.enable then
            {
              alertmanagerSpec = {
                alertmanagerConfiguration = {
                  name = "alertmanager-config";
                };
              };

              config = {
                global.resolve_timeout = "5m";
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
                    }
                    // lib.optionalAttrs cfg.alertmanager.gated {
                      "nginx.ingress.kubernetes.io/auth-signin" =
                        "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                      "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                      "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
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
            }
          else
            { };

        grafana = {
          enabled = cfg.grafana.enable;

          "grafana.ini" = {
            auth = {
              disable_login_form = true;
            };
            "auth.anonymous" = {
              enabled = true;
              org_name = "Main Org.";
              org_role = "Viewer";
            };
          };

          plugins =
            if config.homelab.monitoring.quickwit.enable then
              [
                "quickwit-quickwit-datasource 0.4.5"
              ]
            else
              [ ];

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

          admin =
            if cfg.grafana.passwordAuth.enable then
              {
                existingSecret = "grafana-admin-credentials";
                userKey = "username";
                passwordKey = "password";
              }
            else
              { };
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
                }
                // lib.optionalAttrs cfg.grafana.gated {
                  "nginx.ingress.kubernetes.io/auth-signin" =
                    "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                  "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                  "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
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
                }
                // lib.optionalAttrs cfg.prometheus.gated {
                  "nginx.ingress.kubernetes.io/auth-signin" =
                    "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                  "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                  "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
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

            thanos =
              if cfg.thanos.enable then
                {
                  image = cfg.thanos.image;
                  objectStorageConfig = {
                    name = "thanos-objectstorage";
                    key = "thanos.yaml";
                  };
                }
              else
                { };
          };
        };
      };
    };

    manifests = {
      alertmanager-config.content = {
        apiVersion = "monitoring.coreos.com/v1alpha1";
        kind = "AlertmanagerConfig";
        metadata = {
          name = "alertmanager-config";
          namespace = "monitoring";
        };
        spec = {
          receivers = [
            { name = "null"; }
            {
              name = "default";
              discordConfigs = [
                {
                  apiURL = {
                    name = "alertmanager-config-secrets";
                    key = "DISCORD_WEBHOOK_URL";
                  };
                  content = ''
                    {{- if gt (.Alerts.Firing | len) 0 -}}
                      **Firing:** {{ .Alerts.Firing | len }}
                    {{- end }}
                    {{- if and (gt (.Alerts.Firing | len) 0) (gt (.Alerts.Resolved | len) 0) }} | {{ end -}}
                    {{- if gt (.Alerts.Resolved | len) 0 -}}
                      **Resolved:** {{ .Alerts.Resolved | len }}
                    {{- end -}}
                  '';
                  message = ''
                    {{- if and (gt (.Alerts.Firing | len) 0) (gt (.Alerts.Resolved | len) 0) -}}
                    **Firing:**
                    {{- end }}
                    {{ range .Alerts.Firing }}
                    **‼️ Alert:** {{ .Annotations.summary }}
                    **Severity:** `{{ .Labels.severity }}`
                    **Description:** {{ .Annotations.description }}
                    [**Graph 📈**]({{ .GeneratorURL }})
                    {{- if .Annotations.runbook_url }} [**Runbook 📝**]({{ .Annotations.runbook_url }}){{ end }}
                    **Details:**
                    {{ range (.Labels.Remove (stringSlice "cluster" "provider" "region" "monitor_type" "prometheus")).SortedPairs -}}
                    - **{{ .Name }}:** `{{ .Value }}`
                    {{ end }}
                    {{ end }}


                    {{- if and (gt (.Alerts.Firing | len) 0) (gt (.Alerts.Resolved | len) 0) -}}
                    **Resolved:**
                    {{- end }}
                    {{ range .Alerts.Resolved }}
                    **✅ Alert:** {{ .Annotations.summary }}
                    **Severity:** `{{ .Labels.severity }}`
                    **Description:** {{ .Annotations.description }}
                    [**Graph 📈**]({{ .GeneratorURL }})
                    {{- if .Annotations.runbook_url }} [**Runbook 📝**]({{ .Annotations.runbook_url }}){{ end }}
                    **Details:**
                    {{ range (.Labels.Remove (stringSlice "cluster" "provider" "region" "monitor_type" "prometheus")).SortedPairs -}}
                    - **{{ .Name }}:** `{{ .Value }}`
                    {{ end }}
                    {{ end }}
                  '';
                }
              ];
            }
          ];
          route = {
            receiver = "default";
            groupWait = "30s";
            groupInterval = "5m";
            repeatInterval = "10m";
            routes = [
              {
                receiver = "null";
                matchers = [
                  {
                    name = "alertname";
                    value = "Watchdog";
                    matchType = "=";
                  }
                ];
              }
              {
                receiver = "null";
                matchers = [
                  {
                    name = "alertname";
                    value = "InfoInhibitor";
                    matchType = "=";
                  }
                ];
              }
            ];
          };
        };
      };
    };

    secrets =
      lib.optional (cfg.grafana.enable && cfg.grafana.passwordAuth.enable) {
        metadata = {
          name = "grafana-admin-credentials";
          namespace = "monitoring";
        };
        stringData = {
          password = cfg.grafana.passwordAuth.password;
          username = cfg.grafana.passwordAuth.username;
        };
      }
      ++ lib.optional cfg.alertmanager.enable {
        metadata = {
          name = "alertmanager-config-secrets";
          namespace = "monitoring";
        };
        stringData.DISCORD_WEBHOOK_URL = cfg.alertmanager.discordWebhookUrl;
      }
      ++ lib.optional cfg.thanos.enable {
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
      ++ lib.optional cfg.thanos.enable {
        metadata = {
          name = "thanos-rule-alertmanager";
          namespace = "monitoring";
        };
        stringData."config.yaml" = ''
          global:
            resolve_timeout: 5m
          route:
            receiver: 'default'
            group_by: ['alertname']
            group_wait: 10s
            group_interval: 10s
            repeat_interval: 12h
          receivers:
            - name: 'default'
        '';
      };
  };
}
