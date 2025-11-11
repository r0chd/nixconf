{ config, lib, ... }:
let
  cfg = config.homelab.system.pihole;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.external-dns-endpoints-rbac.content = [
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata.name = "external-dns-endpoints-reader";
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "endpoints" ];
            verbs = [
              "get"
              "list"
              "watch"
            ];
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata.name = "external-dns-endpoints-reader";
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "external-dns-endpoints-reader";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "external-dns";
            namespace = "system";
          }
        ];
      }
    ];
  };
}
