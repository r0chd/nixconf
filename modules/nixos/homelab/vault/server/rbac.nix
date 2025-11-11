{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-server-rbac".content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "Role";
        metadata = {
          name = "vault-k8s-discovery";
          namespace = "vault";
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "pods" ];
            verbs = [
              "get"
              "list"
            ];
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "RoleBinding";
        metadata = {
          name = "vault-k8s-discovery-binding";
          namespace = "vault";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "Role";
          name = "vault-k8s-discovery";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "vault";
            namespace = "vault";
          }
        ];
      }
    ];
  };
}
