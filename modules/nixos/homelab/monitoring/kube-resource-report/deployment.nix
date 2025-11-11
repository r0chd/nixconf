{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kube-resource-report;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.kube-resource-report-deployment.content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          labels = {
            application = "kube-resource-report";
          };
          name = "kube-resource-report";
          namespace = "monitoring";
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels = {
              application = "kube-resource-report";
            };
          };
          template = {
            metadata = {
              labels = {
                application = "kube-resource-report";
              };
            };
            spec = {
              serviceAccountName = "kube-resource-report";
              containers = [
                {
                  name = "kube-resource-report";
                  image = "hjacobs/kube-resource-report:22.11.0";
                  args = [
                    "--update-interval-minutes=1"
                    "--additional-cost-per-cluster=30.0"
                    "/output"
                  ];
                  volumeMounts = [
                    {
                      mountPath = "/output";
                      name = "report-data";
                    }
                  ];
                  inherit (cfg) resources;
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    readOnlyRootFilesystem = true;
                    runAsNonRoot = true;
                    runAsUser = 1000;
                    capabilities = {
                      drop = [ "all" ];
                    };
                  };
                }
                {
                  name = "nginx";
                  image = "nginx:alpine";
                  volumeMounts = [
                    {
                      mountPath = "/usr/share/nginx/html";
                      name = "report-data";
                      readOnly = true;
                    }
                  ];
                  ports = [ { containerPort = 80; } ];
                  readinessProbe = {
                    httpGet = {
                      path = "/";
                      port = 80;
                    };
                  };
                  inherit (cfg.nginx) resources;
                }
              ];
              volumes = [
                {
                  name = "report-data";
                  emptyDir = {
                    sizeLimit = "500Mi";
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
