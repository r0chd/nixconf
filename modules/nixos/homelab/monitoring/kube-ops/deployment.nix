{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.kube-ops;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."kube-ops-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "kube-ops";
          namespace = "monitoring";
        };
        spec = {
          inherit (cfg) replicas;
          selector.matchLabels.application = "kube-ops";
          template = {
            metadata.labels.application = "kube-ops";
            spec = {
              serviceAccountName = "kube-ops";
              containers = [
                {
                  name = "kube-ops";
                  inherit (cfg) image;
                  args = [
                    "--redis-url=redis://kube-ops-dragonfly.monitoring.svc.cluster.local:6379"
                    "--port=8080"
                  ];
                  ports = [
                    {
                      containerPort = 8080;
                    }
                  ];
                  readinessProbe.httpGet = {
                    path = "/health";
                    port = 8080;
                  };
                  inherit (cfg) resources;
                  securityContext = {
                    readOnlyRootFilesystem = true;
                    runAsNonRoot = true;
                    runAsUser = 1000;
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
