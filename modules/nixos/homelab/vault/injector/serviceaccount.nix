{ config, lib, ... }:
{
  config =
    lib.mkIf
      (config.homelab.enable && config.homelab.vault.enable && config.homelab.vault.injector.enable)
      {
        services.k3s.manifests."vault-injector-serviceaccount".content = [
          {
            apiVersion = "v1";
            kind = "ServiceAccount";
            metadata = {
              name = "vault-agent-injector";
              namespace = "vault";
              labels = {
                "app.kubernetes.io/name" = "vault-agent-injector";
                "app.kubernetes.io/instance" = "vault";
              };
            };
          }
        ];
      };
}
