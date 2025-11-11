{ config, lib, ... }:
let
  cfg = config.homelab.moxwiki;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."moxwiki-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "moxwiki";
        };
      }
    ];
  };
}
