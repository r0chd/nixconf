{ config, lib, ... }:
let
  cfg = config.homelab.cert-manager;
in
{
  options.homelab.cert-manager = {
    email = lib.mkOption {
      type = lib.types.str;
      default = "oskarrochowiak@gmail.com";
      description = "Email address for Let's Encrypt certificate requests";
    };
  };

  config.services.k3s.manifests."cert-manager-letsencrypt-issuer".content = [
    {
      apiVersion = "cert-manager.io/v1";
      kind = "ClusterIssuer";
      metadata = {
        name = "letsencrypt";
      };
      spec = {
        acme = {
          server = "https://acme-v02.api.letsencrypt.org/directory";
          inherit (cfg) email;
          privateKeySecretRef = {
            name = "letsencrypt";
          };
          solvers = [
            {
              http01 = {
                ingress = {
                  class = "nginx";
                };
              };
            }
          ];
        };
      };
    }
  ];
}
