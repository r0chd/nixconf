{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.atuin.enable) {
    services.k3s.manifests."atuin-service" = {
      content = [
        #{ TODO: Use flux here
        #  apiVersion = "kustomize.toolkit.fluxcd.io/v1";
        #  kind = "Kustomization";
        #  metadata = {
        #    name = "atuin";
        #    namespace = "flux-system";
        #  };
        #  spec = {
        #    interval = "5m";
        #    path = "./";
        #    prune = true;
        #    sourceRef = {
        #      kind = "OCIRepository";
        #      name = "atuin-manifests";
        #    };
        #    targetNamespace = "atuin";
        #  };
        #}
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
                name = "http";
                port = 8888;
                targetPort = 8888;
              }
            ];
            selector."io.kompose.service" = "atuin";
          };
        }
      ];
    };
  };
}
