{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kuvasz;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."kuvasz-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "kuvasz";
          namespace = "monitoring";
        };
        spec = {
          ports = [
            {
              port = 8080;
              protocol = "TCP";
              targetPort = 8080;
            }
          ];
          selector = {
            app = "kuvasz";
          };
          type = "ClusterIP";
        };
      }
    ];
  };
}
