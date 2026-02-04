{ config, lib, ... }:
let
  cfg = config.homelab.hytale;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.hytale-statefulset.content = [
      {
        apiVersion = "apps/v1";
        kind = "StatefulSet";
        metadata = {
          name = "hytale";
          namespace = "hytale";
          labels = {
            "app.kubernetes.io/name" = "hytale";
          };
        };
        spec = {
          replicas = 1;
          serviceName = "hytale";
          selector.matchLabels.app = "hytale";
          template = {
            metadata.labels.app = "hytale";
            spec.containers = [
              {
                name = "hytale";
                image = "ghcr.io/dustinrouillard/hytale-docker:v1.0.5";
                tty = true;
                stdin = true;
                ports = [
                  {
                    containerPort = 5520;
                    protocol = "UDP";
                  }
                  {
                    containerPort = 5522;
                    protocol = "TCP";
                  }
                ];
                env = [
                  {
                    name = "MIN_MEMORY";
                    value = "4G";
                  }
                  {
                    name = "MAX_MEMORY";
                    value = "8G";
                  }
                  {
                    name = "HTY_PVP_ENABLED";
                    value = "true";
                  }
                  {
                    name = "HTY_FALL_DAMAGE_ENABLED";
                    value = "true";
                  }
                ];
                envFrom = [
                  {
                    secretRef = {
                      name = "hytale-rcon-password";
                    };
                  }
                ];
                volumeMounts = [
                  {
                    name = "hytale-main";
                    mountPath = "/opt";
                  }
                  {
                    name = "hytale-data";
                    mountPath = "/data";
                  }
                ];
                inherit (cfg) resources;
              }
            ];
          };

          volumeClaimTemplates = [
            {
              metadata.name = "hytale-main";
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                resources.requests.storage = "5Gi";
              };
            }
            {
              metadata.name = "hytale-data";
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                resources.requests.storage = cfg.storageSize;
              };
            }
          ];
        };
      }
    ];
  };
}
