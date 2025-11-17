{ config, lib, ... }:
let
  cfg = config.homelab.dex;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."dex-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "dex";
      }
    ];
  };
}
