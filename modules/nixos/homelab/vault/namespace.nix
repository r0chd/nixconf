{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "vault";
      }
    ];
  };
}
