{ config, lib, ... }:
{
  config = lib.mkIf config.homelab.portfolio.enable {
    services.k3s.manifests.portfolio-namespace.content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "portfolio";
      }
    ];
  };
}
