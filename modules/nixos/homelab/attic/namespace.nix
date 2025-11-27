{ config, lib, ... }:
let
  cfg = config.homelab.attic;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."attic-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "attic";
      }
    ];
  };
}
