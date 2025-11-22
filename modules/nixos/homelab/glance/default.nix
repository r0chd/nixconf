{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.homelab.glance;

  layoutConfig = {
    theme = {
      "background-color" = "0 0 16";
      "primary-color" = "43 59 81";
      "positive-color" = "61 66 44";
      "negative-color" = "6 96 59";
    };
    pages = [
      {
        name = "Startpage";
        width = "slim";
        "hide-desktop-navigation" = false;
        "center-vertically" = true;
        columns = [
          {
            size = "small";
            widgets = lib.concatLists [
              (lib.optionals
                (config.homelab.system.pihole.enable && config.homelab.system.pihole.ingressHost != null)
                [
                  {
                    type = "dns-stats";
                    service = "pihole";
                    url = "http://pihole-web.system.svc.cluster.local";
                    token = "19d8aacc17974b9767bba29e6c2409e989ad6485d11385b72e8cb7dd720dc766";
                  }
                ]
              )
              [
                {
                  type = "repository";
                  repository = "r0chd/nixconf";
                  "pull-requests-limit" = 5;
                  "issues-limit" = 3;
                  "commits-limit" = 3;
                }
              ]
              [
                {
                  type = "markets";
                  "symbol-link-template" = "https://www.tradingview.com/symbols/{SYMBOL}/news";
                  markets = [
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                      chart-link = "https://www.tradingview.com/chart/?symbol=KRAKEN:BTCUSD";
                    }
                    {
                      symbol = "ETH-USD";
                      name = "Ethereum";
                      chart-link = "https://www.tradingview.com/chart/?symbol=KRAKEN:ETHUSD";
                    }
                    {
                      symbol = "SOL-USD";
                      name = "Solana";
                      chart-link = "https://www.tradingview.com/chart/?symbol=KRAKEN:SOLUSD";
                    }
                  ];
                }
              ]
              [
                {
                  type = "server-stats";
                  servers = [
                    {
                      type = "local";
                      name = "local";
                      hide-mountpoints-by-default = true;
                      mountpoints = {
                        "/" = {
                          hide = false;
                        };
                        "/opt/data" = {
                          hide = false;
                        };
                      };
                    }
                  ];
                }
              ]
              #{
              #  type = "custom-api";
              #  title = "Immich stats";
              #  cache = "1d";
              #  url = "https://immich.hopki.net/api/server/statistics";
              #  headers = {
              #    "x-api-key" = "12345abcdefghijk";
              #    Accept = "application/json";
              #  };
              #  template = ''
              #    <div class="flex justify-between text-center">
              #      <div>
              #          <div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
              #          <div class="size-h6">PHOTOS</div>
              #      </div>
              #      <div>
              #          <div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
              #          <div class="size-h6">VIDEOS</div>
              #      </div>
              #      <div>
              #          <div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
              #          <div class="size-h6">USAGE</div>
              #      </div>
              #    </div>
              #  '';
              #}
            ];
          }
          {
            size = "full";
            widgets = [
              {
                type = "search";
                autofocus = true;
                "search-engine" = "google";
                "new-tab" = true;
                bangs = [
                  {
                    title = "YouTube";
                    shortcut = "!yt";
                    url = "https://www.youtube.com/results?search_query={QUERY}";
                  }
                  {
                    title = "Github";
                    shortcut = "!gh";
                    url = "https://github.com/search?q={QUERY}&type=repositories";
                  }
                ];
              }
              {
                type = "monitor";
                cache = "1m";
                title = "Monitoring";
                sites =
                  lib.concatLists [
                    # Monitoring stack
                    (lib.optionals
                      (config.homelab.monitoring.grafana.enable && config.homelab.monitoring.grafana.ingressHost != null)
                      [
                        {
                          title = "Grafana";
                          url = "https://${config.homelab.monitoring.grafana.ingressHost}";
                          "check-url" = "http://prometheus-stack-grafana.monitoring.svc.cluster.local:3000";
                          icon = "di:grafana";
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
                          title = "Prometheus";
                          url = "https://${config.homelab.monitoring.prometheus.ingressHost}";
                          "check-url" = "http://prometheus-stack-kube-prom-prometheus.monitoring.svc.cluster.local:9090";
                          icon = "di:prometheus";
                        }
                      ]
                    )
                    (lib.optionals
                      (config.homelab.monitoring.thanos.enable && config.homelab.monitoring.thanos.ingressHost != null)
                      [
                        {
                          title = "Thanos";
                          url = "https://${config.homelab.monitoring.thanos.ingressHost}";
                          "check-url" = "http://thanos-query-frontend.monitoring.svc.cluster.local:9090";
                          icon = "di:thanos";
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
                          title = "Alertmanager";
                          url = "https://${config.homelab.monitoring.alertmanager.ingressHost}";
                          "check-url" = "http://prometheus-stack-kube-prom-alertmanager.monitoring.svc.cluster.local:9093";
                          icon = "di:alertmanager";
                        }
                      ]
                    )
                    (lib.optionals
                      (
                        config.homelab.monitoring.kube-web.enable && config.homelab.monitoring.kube-web.ingressHost != null
                      )
                      [
                        {
                          title = "Kube-Web";
                          url = "https://${config.homelab.monitoring.kube-web.ingressHost}";
                          "check-url" = "http://kube-web-view.monitoring.svc.cluster.local:80";
                          icon = "di:kubernetes";
                        }
                      ]
                    )
                    (lib.optionals
                      (
                        config.homelab.monitoring.kube-ops.enable && config.homelab.monitoring.kube-ops.ingressHost != null
                      )
                      [
                        {
                          title = "Kube-Ops";
                          url = "https://${config.homelab.monitoring.kube-ops.ingressHost}";
                          "check-url" = "http://kube-ops.monitoring.svc.cluster.local:80";
                          icon = "di:kubernetes";
                        }
                      ]
                    )
                    (lib.optionals
                      (
                        config.homelab.monitoring.quickwit.enable && config.homelab.monitoring.quickwit.ingressHost != null
                      )
                      [
                        {
                          title = "Quickwit";
                          url = "https://${config.homelab.monitoring.quickwit.ingressHost}";
                          "check-url" = "http://quickwit-control-plane.monitoring.svc.cluster.local:7280";
                          icon = "sh:quickwit";
                        }
                      ]
                    )
                  ]
                  ++ cfg.additionalServices;
              }
              {
                type = "monitor";
                cache = "1m";
                title = "Web apps";
                sites =
                  lib.concatLists [
                    (lib.optionals (config.homelab.moxwiki.enable && config.homelab.moxwiki.ingressHost != null) [
                      {
                        title = "Portfolio";
                        url = "https://${config.homelab.portfolio.ingressHost}";
                        "check-url" = "http://portfolio.portfolio.svc.cluster.local:80";
                        icon = "si:briefcase";
                      }
                    ])
                    (lib.optionals (config.homelab.moxwiki.enable && config.homelab.moxwiki.ingressHost != null) [
                      {
                        title = "MoxWiki";
                        url = "https://${config.homelab.moxwiki.ingressHost}";
                        "check-url" = "http://moxwiki.moxwiki.svc.cluster.local:80";
                        icon = "si:gitbook";
                      }
                    ])
                    (lib.optionals (config.homelab.vaultwarden.enable && config.homelab.vaultwarden.ingressHost != null)
                      [
                        {
                          title = "Vaultwarden";
                          url = "https://${config.homelab.vaultwarden.ingressHost}";
                          "check-url" = "http://vaultwarden.vaultwarden.svc.cluster.local:80";
                          icon = "sh:vaultwarden";
                        }
                      ]
                    )
                    (lib.optionals (config.homelab.forgejo.enable && config.homelab.forgejo.ingressHost != null) [
                      {
                        title = "Forgejo";
                        url = "https://${config.homelab.forgejo.ingressHost}";
                        "check-url" = "http://forgejo-http.forgejo.svc.cluster.local:3000";
                        icon = "si:forgejo";
                      }
                    ])
                    (lib.optionals (config.homelab.nextcloud.enable && config.homelab.nextcloud.ingressHost != null) [
                      {
                        title = "Nextcloud";
                        url = "https://${config.homelab.nextcloud.ingressHost}";
                        "check-url" = "http://nextcloud.nextcloud.svc.cluster.local:8080";
                        icon = "si:nextcloud";
                      }
                    ])
                  ]
                  ++ cfg.additionalWebsites;
              }
              {
                type = "monitor";
                cache = "1m";
                title = "Security";
                sites = lib.concatLists [
                  (lib.optionals
                    (config.homelab.system.pihole.enable && config.homelab.system.pihole.ingressHost != null)
                    [
                      {
                        title = "Pi-Hole";
                        url = "https://${config.homelab.system.pihole.ingressHost}";
                        "check-url" = "http://pihole-web.system.svc.cluster.local:80";
                        icon = "di:pi-hole";
                      }
                    ]
                  )
                  (lib.optionals (config.homelab.auth.vault.enable && config.homelab.auth.vault.ingressHost != null) [
                    {
                      title = "Vault";
                      url = "https://${config.homelab.auth.vault.ingressHost}";
                      "check-url" = "http://vault.auth.svc.cluster.local:8200";
                      icon = "di:vault";
                    }
                  ])
                ];
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  options.homelab.glance = {
    enable = lib.mkEnableOption "glance";
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "glance.${config.homelab.domain}" else null;
      description = "Hostname for glance ingress (defaults to glance.<domain> if domain is set)";
    };
    additionalServices = lib.mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            title = lib.mkOption {
              type = types.str;
            };
            url = lib.mkOption {
              type = types.str;
            };
            check-url = lib.mkOption {
              type = types.str;
            };
            icon = lib.mkOption { type = types.str; };
          };
        }
      );
      default = [ ];
    };
    additionalWebsites = lib.mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            title = lib.mkOption {
              type = types.str;
            };
            url = lib.mkOption {
              type = types.str;
            };
            check-url = lib.mkOption {
              type = types.str;
              default = null;
            };
            icon = lib.mkOption { type = types.str; };
          };
        }
      );
      default = [ ];
    };
  };

  config.services.k3s = lib.mkIf cfg.enable {
    manifests."glance-certificate".content = lib.optionals (cfg.ingressHost != null) [
      {
        apiVersion = "cert-manager.io/v1";
        kind = "Certificate";
        metadata = {
          name = "glance-tls";
          namespace = "glance";
        };
        spec = {
          secretName = "glance-tls";
          issuerRef = {
            name = "letsencrypt";
            kind = "ClusterIssuer";
          };
          dnsNames = [ cfg.ingressHost ];
        };
      }
    ];

    autoDeployCharts.glance = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://rubxkube.github.io/charts/";
        chart = "glance";
        version = "0.0.9";
        chartHash = "sha256-kET0Lbl7r+hRnxMDOc3GZcahfEjgf2ya+JJgopTMAJQ=";
      };
      targetNamespace = "glance";
      createNamespace = true;
      values.common = {
        name = "glance";
        service = {
          servicePort = 8080;
          containerPort = 8080;
        };
        deployment = {
          port = 8080;
          args = [
            "--config"
            "/mnt/glance.yml"
          ];
        };
        image = {
          repository = "glanceapp/glance";
          tag = "v0.8.3";
          pullPolicy = "IfNotPresent";
        };
        configMap = {
          enabled = true;
          data = [
            {
              name = "config";
              mountPath = "/mnt";
              data = [
                {
                  content = {
                    "glance.yml" = lib.generators.toYAML { } layoutConfig;
                  };
                }
              ];
            }
          ];
        };
        startupProbeEnabled = true;
        startupProbe = {
          httpGet = {
            path = "/";
            port = 8080;
          };
          initialDelaySeconds = 10;
          periodSeconds = 10;
          timeoutSeconds = 5;
          failureThreshold = 3;
        };
        readinessProbeEnabled = false;
        readinessProbe = { };
        livenessProbeEnabled = false;
        livenessProbe = { };
        persistence = {
          enabled = true;
          volumes = [ ];
        };
        ingress = {
          enabled = cfg.ingressHost != null;
        }
        // lib.optionalAttrs (cfg.ingressHost != null) {
          hostName = cfg.ingressHost;
          ingressClassName = "nginx";
          extraLabels = { };
          tls = {
            enabled = true;
            secretName = "glance-tls";
            annotations = {
              "cert-manager.io/cluster-issuer" = "letsencrypt";
            };
          };
        };
      };
    };
  };
}
