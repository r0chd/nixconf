{ config, lib, ... }:
{
  config =
    lib.mkIf
      (config.homelab.enable && config.homelab.vault.enable && config.homelab.vault.injector.enable)
      {
        services.k3s.manifests."vault-injector-service".content = [
          {
            apiVersion = "v1";
            kind = "Service";
            metadata = {
              name = "vault-agent-injector-svc";
              namespace = "vault";
              labels = {
                "app.kubernetes.io/name" = "vault-agent-injector";
                "app.kubernetes.io/instance" = "vault";
              };
            };
            spec = {
              ports = [
                {
                  port = 443;
                  targetPort = 8080;
                }
              ];
              selector = {
                "app.kubernetes.io/name" = "vault-agent-injector";
                "app.kubernetes.io/instance" = "vault";
                component = "webhook";
              };
            };
          }
        ];
      };
}
