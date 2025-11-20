{ config, lib, ... }:
let
  cfg = config.homelab.auth.vault;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests."vault-server-config-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "vault-config";
          namespace = "auth";
          labels = {
            "app.kubernetes.io/name" = "vault";
            "app.kubernetes.io/instance" = "vault";
          };
        };
        data."extraconfig-from-values.hcl" = ''
          disable_mlock = true
          ui = true

          listener "tcp" {
            tls_disable = 1
            address = "0.0.0.0:8200"
            cluster_address = "0.0.0.0:8201"
          }

          api_addr = "http://vault-0.vault.svc.cluster.local:8200"
          cluster_addr = "http://vault-0.vault-internal:8201"

          storage "raft" {
            path = "/vault/data"
            retry_join {
              auto_join_scheme = "http"
              auto_join = "provider=k8s namespace=vault label_selector=\"app.kubernetes.io/name=vault\""
            }
          }
        '';
      }
    ];
  };
}
