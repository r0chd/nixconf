{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.system.reloader.enable) {
    services.k3s.manifests."reloader-clusterrolebinding".content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "reloader-reloader-role-binding";
          labels = {
            app = "reloader-reloader";
            "app.kubernetes.io/managed-by" = "NixOS";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "reloader-reloader-role";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "reloader-reloader";
            namespace = "default";
          }
        ];
      }
    ];
  };
}

