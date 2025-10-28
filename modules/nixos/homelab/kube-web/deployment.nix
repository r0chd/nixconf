{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.kube-web.enable) {
    services.k3s.manifests."kube-web-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "kube-web";
          namespace = "monitoring";
        };
        spec = {
          replicas = 1;
          selector.matchLabels.application = "kube-web-view";
          template = {
            metadata.labels.application = "kube-web-view";
            spec = {
              serviceAccountName = "kube-web-view";
              containers = [
                {
                  name = "kube-web-view";
                  image = "hjacobs/kube-web-view:23.2.0";
                  args = [
                    "--port=8080"
                    "--show-container-logs"
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
