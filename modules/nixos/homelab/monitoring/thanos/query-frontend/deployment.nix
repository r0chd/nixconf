{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."thanos-query-frontend-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "thanos-query-frontend";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/component" = "query-cache";
            "app.kubernetes.io/instance" = "thanos-query-frontend";
            "app.kubernetes.io/name" = "thanos-query-frontend";
            "app.kubernetes.io/version" = "v0.30.2";
          };
        };
        spec = {
          replicas = cfg.queryFrontend.replicas;
          selector.matchLabels = {
            "app.kubernetes.io/component" = "query-cache";
            "app.kubernetes.io/instance" = "thanos-query-frontend";
            "app.kubernetes.io/name" = "thanos-query-frontend";
          };
          template = {
            metadata.labels = {
              "app.kubernetes.io/component" = "query-cache";
              "app.kubernetes.io/instance" = "thanos-query-frontend";
              "app.kubernetes.io/name" = "thanos-query-frontend";
              "app.kubernetes.io/version" = "v0.30.2";
            };
            spec = {
              affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution = [
                {
                  podAffinityTerm = {
                    labelSelector.matchExpressions = [
                      {
                        key = "app.kubernetes.io/name";
                        operator = "In";
                        values = [ "thanos-query-frontend" ];
                      }
                    ];
                    namespaces = [ "monitoring" ];
                    topologyKey = "kubernetes.io/hostname";
                  };
                  weight = 100;
                }
              ];
              containers = [
                {
                  name = "thanos-query-frontend";
                  inherit (cfg) image;
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "query-frontend"
                    "--log.level=info"
                    "--log.format=logfmt"
                    "--query-frontend.compress-responses"
                    "--http-address=0.0.0.0:9090"
                    "--query-frontend.downstream-url=http://thanos-query.monitoring.svc.cluster.local.:9090"
                    "--query-range.split-interval=12h"
                    "--labels.split-interval=12h"
                    "--query-range.max-retries-per-request=10"
                    "--labels.max-retries-per-request=10"
                    "--query-frontend.log-queries-longer-than=10s"
                    "--query-range.response-cache-config=\"config\":\n  \"addresses\":\n  - \"dnssrv+_client._tcp.<MEMCACHED_SERVICE>.monitoring.svc.cluster.local\"\n  \"dns_provider_update_interval\": \"10s\"\n  \"max_async_buffer_size\": 10000\n  \"max_async_concurrency\": 20\n  \"max_get_multi_batch_size\": 0\n  \"max_get_multi_concurrency\": 100\n  \"max_idle_connections\": 100\n  \"timeout\": \"500ms\"\n\"type\": \"memcached\""
                    "--labels.response-cache-config=\"config\":\n  \"addresses\":\n  - \"dnssrv+_client._tcp.<MEMCACHED_SERVICE>.monitoring.svc.cluster.local\"\n  \"dns_provider_update_interval\": \"10s\"\n  \"max_async_buffer_size\": 10000\n  \"max_async_concurrency\": 20\n  \"max_get_multi_batch_size\": 0\n  \"max_get_multi_concurrency\": 100\n  \"max_idle_connections\": 100\n  \"timeout\": \"500ms\"\n\"type\": \"memcached\""
                    "--tracing.config=\"config\":\n  \"sampler_param\": 2\n  \"sampler_type\": \"ratelimiting\"\n  \"service_name\": \"thanos-query-frontend\"\n\"type\": \"JAEGER\""
                  ];
                  env = [
                    {
                      name = "HOST_IP_ADDRESS";
                      valueFrom.fieldRef.fieldPath = "status.hostIP";
                    }
                  ];
                  ports = [
                    {
                      containerPort = 9090;
                      name = "http";
                    }
                  ];
                  livenessProbe = {
                    httpGet = {
                      path = "/-/healthy";
                      port = 9090;
                      scheme = "HTTP";
                    };
                    failureThreshold = 4;
                    periodSeconds = 30;
                  };
                  readinessProbe = {
                    httpGet = {
                      path = "/-/ready";
                      port = 9090;
                      scheme = "HTTP";
                    };
                    failureThreshold = 20;
                    periodSeconds = 5;
                  };
                  inherit (cfg.query-frontend) resources;
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    capabilities.drop = [ "ALL" ];
                    readOnlyRootFilesystem = true;
                    runAsGroup = 65532;
                    runAsNonRoot = true;
                    runAsUser = 65534;
                    seccompProfile = {
                      type = "RuntimeDefault";
                    };
                  };
                  terminationMessagePolicy = "FallbackToLogsOnError";
                }
              ];
              nodeSelector."kubernetes.io/os" = "linux";
              securityContext = {
                fsGroup = 65534;
                runAsGroup = 65532;
                runAsNonRoot = true;
                runAsUser = 65534;
                seccompProfile = {
                  type = "RuntimeDefault";
                };
              };
              serviceAccountName = "thanos-query-frontend";
              terminationGracePeriodSeconds = 120;
            };
          };
        };
      }
    ];
  };
}
