{ config, lib, ... }:
let
  cfg = config.homelab.dex;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."dex-service".content = [
      {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          name = "dex";
          namespace = "dex";
        };
        spec = {
          type = "NodePort";
          ports = [
            {
              name = "dex";
              port = 5556;
              protocol = "TCP";
              targetPort = 5556;
              nodePort = 32000;
            }
          ];
          selector = {
            app = "dex";
          };
        };
      }
    ];
  };
}
