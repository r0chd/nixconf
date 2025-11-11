{ config, lib, ... }:
let
  cfg = config.homelab.system.reloader;
in
{
  config = lib.mkIf (config.homelab.enable && config.homelab.system.reloader.enable) {
    services.k3s.manifests."reloader-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "reloader-reloader";
          namespace = "default";
          labels = {
            app = "reloader-reloader";
            "app.kubernetes.io/managed-by" = "NixOS";
            group = "com.stakater.platform";
            provider = "stakater";
            version = "v1.0.121";
          };
        };
        spec = {
          inherit (cfg) replicas;
          revisionHistoryLimit = 2;
          selector.matchLabels = {
            app = "reloader-reloader";
          };
          template = {
            metadata.labels = {
              app = "reloader-reloader";
              "app.kubernetes.io/managed-by" = "NixOS";
              group = "com.stakater.platform";
              provider = "stakater";
              version = "v1.0.121";
            };
            spec = {
              serviceAccountName = "reloader-reloader";
              securityContext = {
                runAsNonRoot = true;
                runAsUser = 65534;
                seccompProfile = {
                  type = "RuntimeDefault";
                };
              };
              containers = [
                {
                  name = "reloader-reloader";
                  inherit (cfg) image;
                  imagePullPolicy = "IfNotPresent";
                  args = [
                    "--auto-reload-all=true"
                    "--reload-strategy=annotations"
                    "--log-format=json"
                    "--log-level=info"

                  ];
                  securityContext = { };
                  ports = [
                    {
                      name = "http";
                      containerPort = 9090;
                    }
                  ];
                  env = [
                    {
                      name = "GOMAXPROCS";
                      valueFrom.resourceFieldRef.resource = "limits.cpu";
                    }
                    {
                      name = "GOMEMLIMIT";
                      valueFrom.resourceFieldRef.resource = "limits.memory";
                    }
                  ];
                  inherit (cfg) resources;
                  livenessProbe = {
                    httpGet = {
                      path = "/live";
                      port = "http";
                    };
                    timeoutSeconds = 5;
                    failureThreshold = 5;
                    periodSeconds = 10;
                    successThreshold = 1;
                    initialDelaySeconds = 10;
                  };
                  readinessProbe = {
                    httpGet = {
                      path = "/metrics";
                      port = "http";
                    };
                    timeoutSeconds = 5;
                    failureThreshold = 5;
                    periodSeconds = 10;
                    successThreshold = 1;
                    initialDelaySeconds = 10;
                  };
                }
              ];
            };
          };
        };
      }
    ];
  };
}
