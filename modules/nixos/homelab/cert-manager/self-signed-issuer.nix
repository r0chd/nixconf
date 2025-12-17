{ config, lib, ... }:
let
  cfg = config.homelab.cert-manager;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."cert-manager-self-signed-issuer".content = [
      {
        apiVersion = "cert-manager.io/v1";
        kind = "ClusterIssuer";
        metadata.name = "self-signed-issuer";
        spec.selfSigned = { };
      }
    ];
  };
}
