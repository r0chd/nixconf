{ lib, config, ... }:
let
  cfg = config.homelab.attic;
  homelab = config.homelab;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."attic-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "attic-server";
          namespace = "attic";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
        };
        spec = {
          selector = {
            "app.kubernetes.io/name" = "attic-server";
          };
          ports = [
            {
              name = "http";
              port = 8080;
              targetPort = "http";
            }
          ];
        };
      }
      {
        apiVersion = "v1";
        kind = "PersistentVolumeClaim";
        metadata = {
          name = "attic-store";
          namespace = "attic";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
        };
        spec = {
          storageClassName = homelab.storageClass;
          accessModes = [ "ReadWriteOnce" ];
          resources = {
            requests = {
              storage = "50Gi";
            };
          };
        };
      }
    ];
  };
}
