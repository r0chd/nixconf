{ ... }:
{
  services.k3s.manifests."vault-server-config-configmap".content = [
    {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata = {
        name = "vault-config";
        namespace = "vault";
        labels = {
          "app.kubernetes.io/name" = "vault";
          "app.kubernetes.io/instance" = "vault";
        };
      };
      data = {
        extraconfig-from-values.hcl =
          # hcl
          ''
            disable_mlock = true
            ui = true

            listener "tcp" {
              tls_disable = 1
              address = "[::]:8200"
              cluster_address = "[::]:8201"
            }

            storage "consul" {
              path = "vault"
              address = "HOST_IP:8500"
            }
          '';
      };
    }
  ];
}
