{ config, lib, ... }:
{
  config = lib.mkIf config.homelab.hytale.enable {
    services.k3s.manifests.hytale-namespace.content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "hytale";
          labels = {
            "app.kubernetes.io/name" = "hytale";
          };
        };
      }
    ];
  };
}
