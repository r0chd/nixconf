{ config, lib, ... }:
let
  cfg = config.homelab.cloudnative-pg;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.cnpg-deployment.content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "cnpg-controller-manager";
          namespace = "cnpg-system";
          labels."app.kubernetes.io/name" = "cloudnative-pg";
        };
        spec = {
          replicas = 1;
          selector.matchLabels."app.kubernetes.io/name" = "cloudnative-pg";
          template = {
            metadata.labels."app.kubernetes.io/name" = "cloudnative-pg";
            spec = {
              serviceAccountName = "cnpg-manager";
              terminationGracePeriodSeconds = 10;
              securityContext = {
                runAsNonRoot = true;
                seccompProfile.type = "RuntimeDefault";
              };
              containers = [
                {
                  name = "manager";
                  image = cfg.image;
                  imagePullPolicy = "Always";
                  command = [ "/manager" ];
                  args = [
                    "controller"
                    "--leader-elect"
                    "--config-map-name=cnpg-controller-manager-config"
                    "--secret-name=cnpg-controller-manager-config"
                    "--webhook-port=9443"
                  ];
                  env = [
                    {
                      name = "OPERATOR_IMAGE_NAME";
                      value = cfg.image;
                    }
                    {
                      name = "OPERATOR_NAMESPACE";
                      valueFrom.fieldRef.fieldPath = "metadata.namespace";
                    }
                    {
                      name = "MONITORING_QUERIES_CONFIGMAP";
                      value = "cnpg-default-monitoring";
                    }
                  ];
                  ports = [
                    {
                      name = "metrics";
                      containerPort = 8080;
                      protocol = "TCP";
                    }
                    {
                      name = "webhook-server";
                      containerPort = 9443;
                      protocol = "TCP";
                    }
                  ];
                  livenessProbe = {
                    httpGet = {
                      path = "/readyz";
                      port = 9443;
                      scheme = "HTTPS";
                    };
                  };
                  readinessProbe = {
                    httpGet = {
                      path = "/readyz";
                      port = 9443;
                      scheme = "HTTPS";
                    };
                  };
                  startupProbe = {
                    failureThreshold = 6;
                    periodSeconds = 5;
                    httpGet = {
                      path = "/readyz";
                      port = 9443;
                      scheme = "HTTPS";
                    };
                  };
                  resources = {
                    requests = {
                      cpu = "100m";
                      memory = "100Mi";
                    };
                    limits = {
                      cpu = "100m";
                      memory = "200Mi";
                    };
                  };
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    readOnlyRootFilesystem = true;
                    runAsUser = 10001;
                    runAsGroup = 10001;
                    capabilities.drop = [ "ALL" ];
                    seccompProfile.type = "RuntimeDefault";
                  };
                  volumeMounts = [
                    {
                      name = "scratch-data";
                      mountPath = "/controller";
                    }
                    {
                      name = "webhook-certificates";
                      mountPath = "/run/secrets/cnpg.io/webhook";
                    }
                  ];
                }
              ];
              volumes = [
                {
                  name = "scratch-data";
                  emptyDir = { };
                }
                {
                  name = "webhook-certificates";
                  secret = {
                    secretName = "cnpg-webhook-cert";
                    optional = true;
                    defaultMode = 420;
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

