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
          labels = {
            "app.kubernetes.io/name" = "kube-web";
          };
        };
        spec = {
          inherit (cfg) replicas;
          selector.matchLabels."app.kubernetes.io/name" = "kube-web";
          template = {
            metadata = {
              labels."app.kubernetes.io/name" = "kube-web";
              annotations."reloader.stakater.com/auto" = "true";
            };
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
                  resources = cfg.resources;
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
