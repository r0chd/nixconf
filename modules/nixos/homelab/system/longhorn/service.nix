{ lib, config, ... }:
let
  cfg = config.homelab.system.longhorn;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.longhorn-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            app = "longhorn-manager";
          };
          name = "longhorn-backend";
          namespace = "system";
        };
        spec = {
          type = "ClusterIP";
          selector = {
            app = "longhorn-manager";
          };
          ports = [
            {
              name = "manager";
              port = 9500;
              targetPort = "manager";
            }
          ];
        };
      }
      {
        kind = "Service";
        apiVersion = "v1";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            app = "longhorn-ui";
          };
          name = "longhorn-frontend";
          namespace = "system";
        };
        spec = {
          type = "ClusterIP";
          selector = {
            app = "longhorn-ui";
          };
          ports = [
            {
              name = "http";
              port = 80;
              targetPort = "http";
              nodePort = null;
            }
          ];
        };
      }
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            app = "longhorn-admission-webhook";
          };
          name = "longhorn-admission-webhook";
          namespace = "system";
        };
        spec = {
          type = "ClusterIP";
          selector = {
            "longhorn.io/admission-webhook" = "longhorn-admission-webhook";
          };
          ports = [
            {
              name = "admission-webhook";
              port = 9502;
              targetPort = "admission-wh";
            }
          ];
        };
      }
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            "app.kubernetes.io/name" = "longhorn";
            "app.kubernetes.io/instance" = "longhorn";
            app = "longhorn-recovery-backend";
          };
          name = "longhorn-recovery-backend";
          namespace = "system";
        };
        spec = {
          type = "ClusterIP";
          selector = {
            "longhorn.io/recovery-backend" = "longhorn-recovery-backend";
          };
          ports = [
            {
              name = "recovery-backend";
              port = 9503;
              targetPort = "recov-backend";
            }
          ];
        };
      }
    ];
  };
}
