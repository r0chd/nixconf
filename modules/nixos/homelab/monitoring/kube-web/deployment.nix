{ lib, config, ... }:
let
  cfg = config.homelab.monitoring.kube-web;
in
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.kube-web.enable) {
    services.k3s.manifests."kube-web-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "kube-web";
          namespace = "monitoring";
        };
        spec = {
          inherit (cfg) replicas;
          selector.matchLabels.application = "kube-web-view";
          template = {
            metadata.labels.application = "kube-web-view";
            spec = {
              serviceAccountName = "kube-web-view";
              containers = [
                {
                  name = "kube-web-view";
                  inherit (cfg) image;
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
