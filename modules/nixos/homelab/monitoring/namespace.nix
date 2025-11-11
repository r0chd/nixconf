{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable) {
    services.k3s.manifests."monitoring-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "monitoring";
      }
    ];
  };
}
