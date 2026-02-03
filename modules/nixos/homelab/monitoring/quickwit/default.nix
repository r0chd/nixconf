{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.quickwit;
  inherit (lib) types;
in
{
  imports = [ ./db.nix ];

  options.homelab.monitoring.quickwit = {
    enable = lib.mkEnableOption "quickwit";

    s3 = {
      region = lib.mkOption {
        default = config.homelab.garage.s3Region;
        type = types.str;
      };
      access_key_id = lib.mkOption {
        type = types.str;
      };
      secret_access_key = lib.mkOption {
        type = types.str;
      };
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
          if config.homelab.monitoring.quickwit.gated then
            "quickwit.i.${config.homelab.domain}"
          else
            "quickwit.${config.homelab.domain}"
        else
          null;
      description = "Hostname for quickwit ingress (defaults to quickwit.i.<domain> if gated, quickwit.<domain> otherwise)";
    };
    retention = lib.mkOption {
      type = types.submodule {
        options = {
          period = lib.mkOption {
            type = types.str;
          };
          schedule = lib.mkOption {
            type = types.str;
          };
        };
      };
      default = { };
    };

    resources = {
      searcher = lib.mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        description = "Kubernetes resource requests/limits for quickwit searcher container.";
      };
      indexer = lib.mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        description = "Kubernetes resource requests/limits for quickwit indexer container.";
      };
      metastore = lib.mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        description = "Kubernetes resource requests/limits for quickwit metastore container.";
      };
      controlPlane = lib.mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        description = "Kubernetes resource requests/limits for quickwit control_plane container.";
      };
      janitor = lib.mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        description = "Kubernetes resource requests/limits for quickwit janitor container.";
      };
      bootstrap = lib.mkOption {
        type = types.attrsOf (types.attrsOf (types.nullOr types.str));
        description = "Kubernetes resource requests/limits for quickwit bootstrap job.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      autoDeployCharts.quickwit = {
        name = "quickwit";
        repo = "https://helm.quickwit.io";
        version = "0.7.20";
        hash = "sha256-bDW/o15coCO1iys5fw87zyXTLDK5mtfnii09121tvJk=";
        targetNamespace = "monitoring";
        values = {
          searcher = {
            replicaCount = 1;
            resources = cfg.resources.searcher;
            extraVolumes = [
              {
                name = "quickwit-config";
                secret.secretName = "quickwit-config";
              }
            ];
            extraVolumeMounts = [
              {
                name = "quickwit-config";
                mountPath = "/quickwit/quickwit.yaml";
                subPath = "quickwit.yaml";
                readOnly = true;
              }
            ];
          };

          indexer = {
            replicaCount = 1;
            resources = cfg.resources.indexer;
            extraVolumes = [
              {
                name = "quickwit-config";
                secret.secretName = "quickwit-config";
              }
            ];
            extraVolumeMounts = [
              {
                name = "quickwit-config";
                mountPath = "/quickwit/quickwit.yaml";
                subPath = "quickwit.yaml";
                readOnly = true;
              }
            ];
            extraEnv.QW_ENABLE_OTLP_ENDPOINT.value = false;
          };

          seed.indexes = [
            {
              version = "0.8";
              index_id = "logs";
              doc_mapping = {
                mode = "strict";
                field_mappings = [
                  {
                    name = "timestamp_nanos";
                    type = "datetime";
                    input_formats = [ "unix_timestamp" ];
                    output_format = "unix_timestamp_nanos";
                    indexed = false;
                    fast = true;
                    fast_precision = "nanoseconds";
                  }
                  {
                    name = "observed_timestamp_nanos";
                    type = "datetime";
                    input_formats = [ "unix_timestamp" ];
                    output_format = "unix_timestamp_nanos";
                  }
                  {
                    name = "service_name";
                    type = "text";
                    tokenizer = "raw";
                    fast = true;
                  }
                  {
                    name = "severity_text";
                    type = "text";
                    tokenizer = "raw";
                    fast = true;
                  }
                  {
                    name = "severity_number";
                    type = "u64";
                    fast = true;
                  }
                  {
                    name = "body";
                    type = "json";
                    tokenizer = "default";
                  }
                  {
                    name = "attributes";
                    type = "json";
                    tokenizer = "raw";
                    fast = true;
                  }
                  {
                    name = "dropped_attributes_count";
                    type = "u64";
                    indexed = false;
                  }
                  {
                    name = "trace_id";
                    type = "bytes";
                    input_format = "hex";
                    output_format = "hex";
                  }
                  {
                    name = "span_id";
                    type = "bytes";
                    input_format = "hex";
                    output_format = "hex";
                  }
                  {
                    name = "trace_flags";
                    type = "u64";
                    indexed = false;
                  }
                  {
                    name = "resource_attributes";
                    type = "json";
                    tokenizer = "raw";
                    fast = true;
                  }
                  {
                    name = "resource_dropped_attributes_count";
                    type = "u64";
                    indexed = false;
                  }
                  {
                    name = "scope_name";
                    type = "text";
                    tokenizer = "raw";
                    fast = true;
                  }
                  {
                    name = "scope_version";
                    type = "text";
                    tokenizer = "raw";
                  }
                  {
                    name = "scope_attributes";
                    type = "json";
                    tokenizer = "raw";
                  }
                  {
                    name = "scope_dropped_attributes_count";
                    type = "u64";
                    indexed = false;
                  }
                ];
                timestamp_field = "timestamp_nanos";
              };
              inherit (cfg) retention;
            }
          ];

          bootstrap = {
            enabled = true;
            resources = cfg.resources.bootstrap;
          };

          metastore = {
            replicaCount = 1;
            resources = cfg.resources.metastore;
            extraVolumes = [
              {
                name = "quickwit-config";
                secret.secretName = "quickwit-config";
              }
            ];
            extraVolumeMounts = [
              {
                name = "quickwit-config";
                mountPath = "/quickwit/quickwit.yaml";
                subPath = "quickwit.yaml";
                readOnly = true;
              }
            ];
            startupProbe = {
              httpGet = {
                path = "/health/livez";
                port = "rest";
              };
              failureThreshold = 12;
              periodSeconds = 5;
            };
          };

          control_plane = {
            enabled = true;
            resources = cfg.resources.controlPlane;
            extraVolumes = [
              {
                name = "quickwit-config";
                secret.secretName = "quickwit-config";
              }
            ];
            extraVolumeMounts = [
              {
                name = "quickwit-config";
                mountPath = "/quickwit/quickwit.yaml";
                subPath = "quickwit.yaml";
                readOnly = true;
              }
            ];
          };

          janitor = {
            enabled = true;
            resources = cfg.resources.janitor;
          };

          environment.NO_COLOR = 1;

          extraEnv = {
            QW_METASTORE_URI = {
              valueFrom.secretKeyRef = {
                name = "quickwit-db-app";
                key = "uri";
              };
            };
          };

          serviceMonitor = {
            enabled = true;
            interval = "60s";
            scrapeTimeout = "10s";
          };

          configLocation = "/quickwit/quickwit.yaml";

          ingress =
            if cfg.ingressHost != null then
              {
                enabled = true;
                className = "nginx";
                annotations =
                  lib.optionalAttrs config.homelab.cert-manager.enable {
                    "cert-manager.io/cluster-issuer" = "letsencrypt";
                  }
                  // lib.optionalAttrs cfg.gated {
                    "nginx.ingress.kubernetes.io/auth-signin" =
                      "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                    "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                    "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
                  };
                hosts = [
                  {
                    host = cfg.ingressHost;
                    paths = [
                      {
                        path = "/";
                        pathType = "Prefix";
                      }
                    ];
                  }
                ];
                tls = [
                  {
                    secretName = "quickwit-tls";
                    hosts = [ cfg.ingressHost ];
                  }
                ];
              }
            else
              { };
        };
      };

      secrets = [
        {
          metadata = {
            name = "quickwit-config";
            namespace = "monitoring";
          };
          stringData = {
            "quickwit.yaml" =
              # yaml
              ''
                version: 0.8
                default_index_root_uri: s3://quickwit/indexes
                storage:
                  s3:
                    flavor: garage
                    region: ${cfg.s3.region}
                    endpoint: https://s3.${config.homelab.garage.ingressHost}
                    access_key_id: ${cfg.s3.access_key_id}
                    secret_access_key: ${cfg.s3.secret_access_key}
              '';
          };
        }
      ];
    };
  };
}
