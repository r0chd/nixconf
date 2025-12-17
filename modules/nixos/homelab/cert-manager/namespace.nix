{ config, lib, ... }:
let
  cfg = config.homelab.cert-manager;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."cert-manager-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "cert-manager";
          labels = {
            "app.kubernetes.io/name" = "cert-manager";
          };
        };
      }
    ];
  };
}
