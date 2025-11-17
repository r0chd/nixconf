{ config, lib, ... }:
let
  cfg = config.homelab.dex;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests."dex-namespace".content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          labels = {
            app = "dex";
          };
          name = "dex";
          namespace = "dex";
        };
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRole";
        metadata = {
          name = "dex";
        };
        rules = [
          {
            apiGroups = [ "dex.coreos.com" ];
            resources = [ "*" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "apiextensions.k8s.io" ];
            resources = [ "customresourcedefinitions" ];
            verbs = [ "create" ];
          }
        ];
      }
      {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "dex";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "dex";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "dex";
            namespace = "dex";
          }
        ];
      }
    ];
  };
}
