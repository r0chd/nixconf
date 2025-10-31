{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-injector-clusterrole".content = [
    {
      apiVersion = "rbac.authorization.k8s.io/v1";
      kind = "ClusterRole";
      metadata = {
        name = "vault-agent-injector-clusterrole";
        labels = {
          "app.kubernetes.io/name" = "vault-agent-injector";
          "app.kubernetes.io/instance" = "vault";
        };
      };
      rules = [
        {
          apiGroups = [ "admissionregistration.k8s.io" ];
          resources = [ "mutatingwebhookconfigurations" ];
          verbs = [
            "get"
            "list"
            "watch"
            "patch"
            "update"
            "create"
          ];
        }
        {
          apiGroups = [ "" ];
          resources = [ "secrets" ];
          verbs = [
            "get"
            "list"
            "watch"
            "create"
            "update"
            "patch"
          ];
        }
      ];
    }
    ];
  };
}
