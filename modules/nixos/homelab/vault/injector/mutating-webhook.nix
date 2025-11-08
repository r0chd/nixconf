{ config, lib, ... }:
{
  config =
    lib.mkIf
      (config.homelab.enable && config.homelab.vault.enable && config.homelab.vault.injector.enable)
      {
        services.k3s.manifests."vault-injector-mutating-webhook".content = [
          {
            apiVersion = "admissionregistration.k8s.io/v1";
            kind = "MutatingWebhookConfiguration";
            metadata = {
              name = "vault-agent-injector-cfg";
              labels = {
                "app.kubernetes.io/name" = "vault-agent-injector";
                "app.kubernetes.io/instance" = "vault";
              };
            };
            webhooks = [
              {
                name = "vault.hashicorp.com";
                admissionReviewVersions = [
                  "v1"
                  "v1beta1"
                ];
                sideEffects = "None";
                clientConfig = {
                  service = {
                    name = "vault-agent-injector-svc";
                    namespace = "vault";
                    path = "/mutate";
                  };
                  caBundle = "";
                };
                rules = [
                  {
                    operations = [
                      "CREATE"
                      "UPDATE"
                    ];
                    apiGroups = [ "" ];
                    apiVersions = [ "v1" ];
                    resources = [ "pods" ];
                  }
                ];
                failurePolicy = "Ignore";
              }
            ];
          }
        ];
      };
}
