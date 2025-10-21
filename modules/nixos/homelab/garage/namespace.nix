{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.garage.enable) {
    services.k3s.manifests.garage-namespace.content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "garage";
      }
    ];
  };
}
