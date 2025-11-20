{ lib, config, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-rbac".content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "Role";
        metadata = {
          name = "vault-k8s-discovery";
          namespace = "auth";
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
          namespace = "auth";
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
            namespace = "auth";
          }
        ];
      }
    ];
  };
}
