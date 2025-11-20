{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-clusterrolebinding".content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "vault-server-binding";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "system:auth-delegator";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "vault";
            namespace = "auth";
          }
        ];
      }
    ];
  };
}
