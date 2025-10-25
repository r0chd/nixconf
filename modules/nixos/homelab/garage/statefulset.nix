{ config, lib, ... }:
let
  cfg = config.homelab.garage;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.garage-statefulset.content = [
      {
        apiVersion = "apps/v1";
        kind = "StatefulSet";
        metadata = {
          name = "garage";
          namespace = "garage";
        };
        spec = {
          serviceName = "garage";
          inherit (cfg) replicas;
          selector.matchLabels.app = "garage";
          template = {
            metadata.labels.app = "garage";
            spec = {
              containers = [
                {
                  name = "garage";
                  inherit (cfg) image;
                  ports = [
                    {
                      containerPort = 3900;
                      name = "s3-api";
                    }
                    {
                      containerPort = 3901;
                      name = "rpc";
                    }
                    {
                      containerPort = 3902;
                      name = "admin";
                    }
                    {
                      containerPort = 3903;
                      name = "web";
                    }
                  ];
                  volumeMounts = [
                    {
                      name = "data";
                      mountPath = "/data";
                    }
                    {
                      name = "meta";
                      mountPath = "/meta";
                    }
                    {
                      name = "config";
                      mountPath = "/etc/garage.toml";
                      subPath = "garage.toml";
                    }
                    {
                      name = "secrets";
                      mountPath = "/secrets";
                      readOnly = true;
                    }
                  ];
                }
              ];
              volumes = [
                {
                  name = "config";
                  configMap.name = "garage-config";
                }
                {
                  name = "secrets";
                  secret = {
                    secretName = "garage-secrets";
                    defaultMode = 384; # 0600 in octal = 384 in decimal
                  };
                }
              ];
            };
          };
          volumeClaimTemplates = [
            {
              metadata.name = "data";
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                storageClassName = cfg.storage.storageClass;
                resources.requests.storage = cfg.storage.dataSize;
              };
            }
            {
              metadata.name = "meta";
              spec = {
                accessModes = [ "ReadWriteOnce" ];
                storageClassName = cfg.storage.storageClass;
                resources.requests.storage = cfg.storage.metaSize;
              };
            }
          ];
        };
      }
    ];
  };
}
