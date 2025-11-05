{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.thanos;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."thanos-query-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "thanos-query";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/component" = "query-layer";
            "app.kubernetes.io/instance" = "thanos-query";
            "app.kubernetes.io/name" = "thanos-query";
            "app.kubernetes.io/version" = "v0.30.2";
          };
        };
        spec = {
          replicas = cfg.query.replicas;
          selector.matchLabels = {
            "app.kubernetes.io/component" = "query-layer";
            "app.kubernetes.io/instance" = "thanos-query";
            "app.kubernetes.io/name" = "thanos-query";
          };
          template = {
            metadata.labels = {
              "app.kubernetes.io/component" = "query-layer";
              "app.kubernetes.io/instance" = "thanos-query";
              "app.kubernetes.io/name" = "thanos-query";
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
                        values = [ "thanos-query" ];
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
                  name = "thanos-query";
                  image = cfg.image;
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "query"
                    "--grpc-address=0.0.0.0:10901"
                    "--http-address=0.0.0.0:9090"
                    "--log.level=debug"
                    "--log.format=logfmt"
                    "--query.replica-label=prometheus_replica"
                    "--query.replica-label=rule_replica"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-receive.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-rule.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-sidecar.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-store.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-receive-default.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-receive-region-1.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-store-0.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-store-1.monitoring.svc.cluster.local"
                    "--endpoint=dnssrv+_grpc._tcp.thanos-store-2.monitoring.svc.cluster.local"
                    "--query.timeout=5m"
                    "--query.lookback-delta=15m"
                    "--tracing.config=\"config\":\n  \"sampler_param\": 2\n  \"sampler_type\": \"ratelimiting\"\n  \"service_name\": \"thanos-query\"\n\"type\": \"JAEGER\""
                    "--query.auto-downsampling"
                  ];
                  env = [
                    {
                      name = "HOST_IP_ADDRESS";
                      valueFrom.fieldRef.fieldPath = "status.hostIP";
                    }
                  ];
                  ports = [
                    {
                      containerPort = 10901;
                      name = "grpc";
                    }
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
                  resources = {
                    limits = {
                      cpu = "0.42";
                      memory = "420Mi";
                    };
                    requests = {
                      cpu = "0.123";
                      memory = "123Mi";
                    };
                  };
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
              serviceAccountName = "thanos-query";
              terminationGracePeriodSeconds = 120;
            };
          };
        };
      }
    ];
  };
}

