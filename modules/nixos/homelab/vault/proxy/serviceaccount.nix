{ config, lib, ... }:
{
  config =
    lib.mkIf (config.homelab.enable && config.homelab.vault.enable && config.homelab.vault.proxy.enable)
      {
        services.k3s.manifests."vault-proxy-serviceaccount".content = [
          {
            apiVersion = "v1";
            kind = "ServiceAccount";
            metadata = {
              name = "vault-proxy";
              namespace = "vault";
              labels = {
                "app.kubernetes.io/name" = "vault-proxy";
                "app.kubernetes.io/instance" = "vault";
              };
            };
          }
        ];
      };
}
