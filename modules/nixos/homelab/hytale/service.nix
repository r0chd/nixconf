{ config, lib, ... }:
let
  cfg = config.homelab.hytale;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.hytale-service.content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "hytale";
          namespace = "hytale";
          labels = {
            "app.kubernetes.io/name" = "hytale";
          };
        };
        spec = {
          type = "LoadBalancer";
          externalTrafficPolicy = "Local";
          ports = [
            {
              name = "game";
              port = 5520;
              protocol = "UDP";
              targetPort = 5520;
              nodePort = 30698;
            }
            {
              name = "hyrcon";
              port = 5522;
              protocol = "TCP";
              targetPort = 5522;
              nodePort = 30699;
            }
          ];
          selector.app = "hytale";
        };
      }
    ];
  };
}
