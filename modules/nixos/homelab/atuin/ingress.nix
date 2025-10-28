{ config, lib, ... }:
let
  cfg = config.homelab.atuin;
  inherit (lib) types;
in
{
  options.homelab.atuin.ingressHost = lib.mkOption {
    type = types.str;
  };

  config = lib.mkIf (config.homelab.enable && cfg.enable) {
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
              host = cfg.ingressHost;
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
