{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) {
    services.k3s.manifests."atuin-namespace".content = [
      {
        apiVersion = "v1";
        kind = "Namespace";
        metadata.name = "atuin";
      }
    ];
  };
}

