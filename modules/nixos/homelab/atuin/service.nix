{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) {
    services.k3s.manifests."atuin-service".content = [
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        labels."io.kompose.service" = "atuin";
        name = "atuin";
        namespace = "atuin";
      };
      spec = {
        type = "NodePort";
        ports = [
          {
            name = 8888;
            port = 8888;
          }
        ];
        selector."io.kompose.service" = "atuin";
      };
    }
    ];
  };
}
