{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-injector-clusterrolebinding".content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "vault-agent-injector-binding";
          namespace = "vault";
          labels = {
            "app.kubernetes.io/name" = "vault-agent-injector";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "vault-agent-injector-clusterrole";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "vault-agent-injector";
            namespace = "vault";
          }
        ];
      }
    ];
  };
}
