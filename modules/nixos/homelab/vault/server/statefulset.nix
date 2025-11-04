{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-server-statefulset".content = [
      {
        apiVersion = "apps/v1";
        kind = "StatefulSet";
        metadata = {
          name = "vault";
          namespace = "vault";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
          annotations."kubernetes.io/ingress.class" = "nginx";
        };
        spec = {
          serviceName = "vault";
          podManagementPolicy = "Parallel";
          replicas = config.homelab.vault.replicas;
          updateStrategy.type = "OnDelete";
          selector.matchLabels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
            component = "server";
          };
          template = {
            metadata.labels = {
              "app.kubernetes.io/name" = "vault";
              "app.kubernetes.io/instance" = "vault";
              component = "server";
            };
            spec = {
              affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution = [
                {
                  weight = 100;
                  podAffinityTerm = {
                    labelSelector.matchLabels = {
                      "app.kubernetes.io/name" = "vault";
                      "app.kubernetes.io/instance" = "vault";
                      component = "server";
                    };
                    topologyKey = "kubernetes.io/hostname";
                  };
                }
              ];
              terminationGracePeriodSeconds = 10;
              serviceAccountName = "vault";

              volumes = [
                {
                  name = "config";
                  configMap.name = "vault-config";
                }
              ];
              containers = [
                {
                  name = "vault";
                  image = config.homelab.vault.image;
                  resources = {
                    limits = {
                      cpu = "250m";
                      memory = "256Mi";
                    };
                    requests = {
                      cpu = "250m";
                      memory = "256Mi";
                    };
                  };
                  securityContext.capabilities.add = [ "IPC_LOCK" ];
                  imagePullPolicy = "IfNotPresent";
                  command = [
                    "/bin/sh"
                    "-ec"
                  ];
                  args = [
                    ''
                      sed -E "s/HOST_IP/$HOST_IP/g" /vault/config/extraconfig-from-values.hcl | \
                      sed -E "s/POD_IP/$POD_IP/g" > /tmp/storageconfig.hcl;
                      /usr/local/bin/docker-entrypoint.sh vault server -config=/tmp/storageconfig.hcl
                    ''
                  ];
                  env = [
                    {
                      name = "HOST_IP";
                      valueFrom.fieldRef.fieldPath = "status.hostIP";
                    }
                    {
                      name = "POD_IP";
                      valueFrom.fieldRef.fieldPath = "status.podIP";
                    }
                    {
                      name = "VAULT_ADDR";
                      value = "http://127.0.0.1:8200";
                    }
                    {
                      name = "SKIP_CHOWN";
                      value = "true";
                    }
                    {
                      name = "SKIP_SETCAP";
                      value = "true";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "config";
                      mountPath = "/vault/config";
                    }
                  ];
                }
              ];
            };
          };
        };
      }
    ];
  };
}
