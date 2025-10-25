{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) {
    services.k3s.manifests."atuin-ingress".content = [
    {
      apiVersion = "networking.k8s.io/v1";
      kind = "Ingress";
      metadata = {
        name = "atuin-ingress";
        namespace = "atuin";
      };
      spec = {
        ingressClassName = "nginx";
        rules = [
          {

            host = "atuin.example.com";
            http = {
              paths = [
                {
                  path = "/";
                  pathType = "Prefix";
                  backend = {
                    service = {
                      name = "atuin";
                      port.number = 8888;
                    };
                  };
                }
              ];
            };
          }
        ];
      };
    }
    ];
  };
}
