{ config, lib, ... }:
let
  cfg = config.homelab.vault;
in
{
  config =
    lib.mkIf (config.homelab.enable && config.homelab.vault.enable && config.homelab.vault.proxy.enable)
      {
        services.k3s.manifests."vault-proxy-config-configmap".content = [
          {
            apiVersion = "v1";
            kind = "ConfigMap";
            metadata = {
              name = "vault-proxy-config";
              namespace = "vault";
              labels = {
                "app.kubernetes.io/name" = "vault-proxy";
                "app.kubernetes.io/instance" = "vault";
              };
            };
            data."vault-proxy.hcl" = ''
              pid_file = "/tmp/vault-proxy.pid"

              vault {
                address = "http://vault.vault.svc.cluster.local:8200"
              }

              listener "tcp" {
                address = "0.0.0.0:8200"
                tls_disable = 1
              }

              api_proxy {
                use_auto_auth_token = false
              }

              cache {
                use_auto_auth_token = false
              }
            '';
          }
        ];
      };
}
