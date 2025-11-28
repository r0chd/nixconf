{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-statefulset".content = [
      {
        apiVersion = "apps/v1";
        kind = "StatefulSet";
        metadata = {
          name = "vault";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
          annotations."kubernetes.io/ingress.class" = "nginx";
        };
        spec = {
          serviceName = "vault";
          podManagementPolicy = "Parallel";
          inherit (cfg) replicas;
          updateStrategy.type = "OnDelete";
          selector.matchLabels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
            component = "server";
          };
          template = {
            metadata = {
              labels = {
                "app.kubernetes.io/name" = "vault";
                "app.kubernetes.io/instance" = "vault";
                component = "server";
              };
              annotations."reloader.stakater.com/auto" = "true";
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
                {
                  name = "data";
                  persistentVolumeClaim.claimName = "vault-data";
                }
              ];
              containers = [
                {
                  name = "vault";
                  inherit (cfg) image;
                  inherit (cfg) resources;
                  securityContext.capabilities.add = [ "IPC_LOCK" ];
                  imagePullPolicy = "IfNotPresent";
                  command = [
                    "/bin/sh"
                    "-ec"
                  ];
                  args = [
                    ''
                      /usr/local/bin/docker-entrypoint.sh vault server -config=/vault/config/extraconfig-from-values.hcl
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
                    {
                      name = "data";
                      mountPath = "/vault/data";
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
