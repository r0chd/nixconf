{ config, lib, ... }:
let
  cfg = config.homelab.vault.proxy;
in
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable && cfg.enable) {
    services.k3s.manifests."vault-proxy-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
        metadata = {
          name = "vault-proxy";
          namespace = "vault";
          labels = {
            "app.kubernetes.io/name" = "vault-proxy";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        spec = {
          inherit (cfg) replicas;
          selector.matchLabels = {
            "app.kubernetes.io/name" = "vault-proxy";
            "app.kubernetes.io/instance" = "vault";
            component = "proxy";
          };
          template = {
            metadata.labels = {
              "app.kubernetes.io/name" = "vault-proxy";
              "app.kubernetes.io/instance" = "vault";
              component = "proxy";
            };
            spec = {
              terminationGracePeriodSeconds = 10;
              serviceAccountName = "vault-proxy";

              volumes = [
                {
                  name = "config";
                  configMap.name = "vault-proxy-config";
                }
              ];
              containers = [
                {
                  name = "vault-proxy";
                  inherit (config.homelab.vault) image;
                  resources = {
                    limits = {
                      cpu = "100m";
                      memory = "128Mi";
                    };
                    requests = {
                      cpu = "50m";
                      memory = "64Mi";
                    };
                  };
                  imagePullPolicy = "IfNotPresent";
                  command = [
                    "vault"
                    "agent"
                    "-config=/vault/config/vault-proxy.hcl"
                  ];
                  env = [
                    {
                      name = "VAULT_ADDR";
                      value = "http://vault.vault.svc.cluster.local:8200";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "config";
                      mountPath = "/vault/config";
                    }
                  ];
                  ports = [
                    {
                      name = "http";
                      containerPort = 8200;
                    }
                  ];
                  readinessProbe = {
                    httpGet = {
                      path = "/v1/sys/health";
                      port = 8200;
                    };
                    initialDelaySeconds = 5;
                    periodSeconds = 5;
                    timeoutSeconds = 3;
                    failureThreshold = 3;
                  };
                  livenessProbe = {
                    httpGet = {
                      path = "/v1/sys/health";
                      port = 8200;
                    };
                    initialDelaySeconds = 10;
                    periodSeconds = 10;
                    timeoutSeconds = 3;
                    failureThreshold = 3;
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
