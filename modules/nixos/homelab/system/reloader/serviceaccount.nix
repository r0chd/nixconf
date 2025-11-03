{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.system.reloader.enable) {
    services.k3s.manifests."reloader-serviceaccount".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "reloader-reloader";
          namespace = "default";
          labels = {
            app = "reloader-reloader";
            "app.kubernetes.io/managed-by" = "NixOS";
          };
        };
      }
    ];
  };
}

