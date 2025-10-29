{ lib, config, ... }:
let
  cfg = config.homelab.kube-ops;
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
          replicas = 1;
          selector.matchLabels.application = "kube-ops";
          template = {
            metadata.labels.application = "kube-ops";
            spec = {
              serviceAccountName = "kube-ops";
              containers = [
                {
                  name = "kube-ops";
                  image = "hjacobs/kube-ops-view:23.2.0";
                  args = [
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
                  resources = {
                    limits.memory = "100Mi";
                    requests = {
                      cpu = "5m";
                      memory = "100Mi";
                    };
                  };
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
