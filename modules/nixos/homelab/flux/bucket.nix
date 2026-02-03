{ lib, config, ... }:
let
  cfg = config.homelab.flux;
in
{
  services.k3s.manifests."flux-bucket".content = [
    {
      apiVersion = "source.toolkit.fluxcd.io/v1";
      kind = "Bucket";
      metadata = {
        name = "s3-bucket";
        namespace = "flux-system";
      };
      spec = {
        interval = "1m";
        bucketName = "flux";
        provider = "aws";
        secretRef.name = "flux-s3-credentials";
        inherit (cfg) endpoint;
      };
    }
  ];
}
