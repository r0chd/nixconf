{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kuvasz;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."kuvasz-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "kuvasz-config";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "kuvasz";
          };
        };
        data = {
          "kuvasz.yml" = lib.generators.toYAML { } {
            kuvasz = {
              "http-communication-log-enabled" = true;
              "log-handler-enabled" = true;
              "data-retention-days" = cfg.retentionDays;
            };
            "http-monitors-external-modifications-enabled" = false;
            "http-monitors" = lib.concatLists [
              (lib.optionals
                (config.homelab.monitoring.grafana.enable && config.homelab.monitoring.grafana.ingressHost != null)
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Grafana";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://prometheus-stack-grafana.monitoring.svc.cluster.local:3000";
                  }
                ]
              )
              (lib.optionals
                (
                  config.homelab.monitoring.prometheus.enable
                  && config.homelab.monitoring.prometheus.ingressHost != null
                )
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Prometheus";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://prometheus-stack-kube-prom-prometheus.monitoring.svc.cluster.local:9090/-/healthy";
                  }
                ]
              )
              (lib.optionals
                (config.homelab.monitoring.thanos.enable && config.homelab.monitoring.thanos.ingressHost != null)
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Thanos";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://thanos-query-frontend.monitoring.svc.cluster.local:9090";
                  }
                ]
              )
              (lib.optionals
                (
                  config.homelab.monitoring.alertmanager.enable
                  && config.homelab.monitoring.alertmanager.ingressHost != null
                )
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Alertmanager";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://prometheus-stack-kube-prom-alertmanager.monitoring.svc.cluster.local:9093";
                  }
                ]
              )
              (lib.optionals
                (
                  config.homelab.monitoring.kube-web.enable && config.homelab.monitoring.kube-web.ingressHost != null
                )
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Kube-Web";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://kube-web-view.monitoring.svc.cluster.local:80/health";
                  }
                ]
              )
              (lib.optionals
                (
                  config.homelab.monitoring.kube-ops.enable && config.homelab.monitoring.kube-ops.ingressHost != null
                )
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Kube-Ops";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://kube-ops.monitoring.svc.cluster.local:80";
                  }
                ]
              )
              (lib.optionals
                (
                  config.homelab.monitoring.quickwit.enable && config.homelab.monitoring.quickwit.ingressHost != null
                )
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Quickwit";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://quickwit-control-plane.monitoring.svc.cluster.local:7280/health/livez";
                  }
                ]
              )
              (lib.optionals
                (config.homelab.monitoring.kuvasz.enable && config.homelab.monitoring.kuvasz.ingressHost != null)
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Kuvasz";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://kuvasz.monitoring.svc.cluster.local:8080";
                  }
                ]
              )
              (lib.optionals (config.homelab.portfolio.enable && config.homelab.portfolio.ingressHost != null) [
                {
                  enabled = true;
                  expected-status-codes = [
                    200
                    201
                    303
                  ];
                  follow-redirects = true;
                  force-no-cache = true;
                  latency-history-enabled = true;
                  name = "Portfolio";
                  request-method = "GET";
                  ssl-check-enabled = false;
                  uptime-check-interval = 60;
                  url = "http://portfolio.portfolio.svc.cluster.local:80";
                }
              ])
              (lib.optionals (config.homelab.moxwiki.enable && config.homelab.moxwiki.ingressHost != null) [
                {
                  enabled = true;
                  expected-status-codes = [
                    200
                    201
                    303
                  ];
                  follow-redirects = true;
                  force-no-cache = true;
                  latency-history-enabled = true;
                  name = "MoxWiki";
                  request-method = "GET";
                  ssl-check-enabled = false;
                  uptime-check-interval = 60;
                  url = "http://moxwiki.moxwiki.svc.cluster.local:80";
                }
              ])
              (lib.optionals (config.homelab.vaultwarden.enable && config.homelab.vaultwarden.ingressHost != null)
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Vaultwarden";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://vaultwarden.vaultwarden.svc.cluster.local:80";
                  }
                ]
              )
              (lib.optionals (config.homelab.forgejo.enable && config.homelab.forgejo.ingressHost != null) [
                {
                  enabled = true;
                  expected-status-codes = [
                    200
                    201
                    303
                  ];
                  follow-redirects = true;
                  force-no-cache = true;
                  latency-history-enabled = true;
                  name = "Forgejo";
                  request-method = "GET";
                  ssl-check-enabled = false;
                  uptime-check-interval = 60;
                  url = "http://forgejo-http.forgejo.svc.cluster.local:3000";
                }
              ])
              (lib.optionals (config.homelab.nextcloud.enable && config.homelab.nextcloud.ingressHost != null) [
                {
                  enabled = true;
                  expected-status-codes = [
                    200
                    201
                    303
                  ];
                  follow-redirects = true;
                  force-no-cache = true;
                  latency-history-enabled = true;
                  name = "Nextcloud";
                  request-method = "GET";
                  ssl-check-enabled = false;
                  uptime-check-interval = 60;
                  url = "http://nextcloud.nextcloud.svc.cluster.local:8080";
                }
              ])
              (lib.optionals
                (config.homelab.system.pihole.enable && config.homelab.system.pihole.ingressHost != null)
                [
                  {
                    enabled = true;
                    expected-status-codes = [
                      200
                      201
                      303
                    ];
                    follow-redirects = true;
                    force-no-cache = true;
                    latency-history-enabled = true;
                    name = "Pi-Hole";
                    request-method = "GET";
                    ssl-check-enabled = false;
                    uptime-check-interval = 60;
                    url = "http://pihole-web.system.svc.cluster.local:80";
                  }
                ]
              )
              (lib.optionals (config.homelab.auth.vault.enable && config.homelab.auth.vault.ingressHost != null) [
                {
                  enabled = true;
                  expected-status-codes = [
                    200
                    201
                    303
                  ];
                  follow-redirects = true;
                  force-no-cache = true;
                  latency-history-enabled = true;
                  name = "Vault";
                  request-method = "GET";
                  ssl-check-enabled = false;
                  uptime-check-interval = 60;
                  url = "http://vault.auth.svc.cluster.local:8200/v1/sys/health";
                }
              ])
            ];
          };
        };
      }
    ];
  };
}
