{ lib, config, ... }:
let
  cfg = config.homelab.auth.dex;
  inherit (lib) types;
in
{
  options.homelab.auth.dex = {
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "dex.${config.homelab.domain}" else null;
      description = "Hostname for dex ingress (defaults to dex.<domain> if domain is set)";
    };
  };

  config = lib.mkIf config.homelab.auth.enable {
    services.k3s = {
      autoDeployCharts.dex = {
        name = "dex";
        repo = "https://charts.dexidp.io";
        version = "0.24.0";
        hash = "sha256-JNSGrCGCuRlIOphAM5mXRDeTzmN+PxDTerMoTqoinTM=";
        targetNamespace = "auth";

        values = {
          replicaCount = 1;

          envFrom = [
            {
              secretRef = {
                name = "vault-client-credentials";
              };
            }
            {
              secretRef = {
                name = "github-client-credentials";
              };
            }
            {
              secretRef = {
                name = "dex-oauth2-client-secret";
              };
            }
          ];

          configSecret = {
            create = false;
            name = "dex-config";
          };

          serviceAccount = {
            create = true;
            annotations = { };
            name = "";
          };
          rbac = {
            create = true;
            createClusterScoped = true;
          };

          ingress =
            if cfg.ingressHost != null then
              {
                enabled = true;
                className = "nginx";
                annotations = {
                  "cert-manager.io/cluster-issuer" = "letsencrypt";
                };
                hosts = [
                  {
                    host = cfg.ingressHost;
                    paths = [
                      {
                        path = "/";
                        pathType = "ImplementationSpecific";
                      }
                    ];
                  }
                ];
                tls = [
                  {
                    secretName = "dex-tls";
                    hosts = [ cfg.ingressHost ];
                  }
                ];
              }
            else
              { };
        };
      };

      secrets = [
        {
          metadata = {
            name = "dex-config";
            namespace = "auth";
          };
          stringData = {
            "config.yaml" = ''
              issuer: https://${cfg.ingressHost}
              staticClients:
                - id: oauth2-proxy
                  secret: '${config.homelab.auth.clientSecret}'
                  name: 'OAuth2 Proxy'
                  redirectURIs:
                    - 'https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/callback'
                - id: vault
                  secret: '${config.homelab.auth.vault.clientSecret}'
                  name: 'Vault'
                  redirectURIs:
                    - https://${config.homelab.auth.vault.ingressHost}/ui/vault/auth/oidc/callback
                    - https://${config.homelab.auth.vault.ingressHost}/v1/auth/oidc/oidc/callback
                    - http://localhost:8250/oidc/callback
              storage:
                type: kubernetes
                config:
                  inCluster: true
              web:
                http: "0.0.0.0:5556"

              connectors:  
              ${lib.optionalString config.homelab.auth.github.enable ''
                - type: github  
                  id: github  
                  name: GitHub  
                  config:  
                    clientID: ${config.homelab.auth.github.clientId}  
                    clientSecret: $GITHUB_CLIENT_SECRET  
                    redirectURI: https://${cfg.ingressHost}/callback  
                    orgs:
                      - name: ${config.homelab.auth.github.org}
              ''}  
            '';
          };
        }
      ];
    };
  };
}
