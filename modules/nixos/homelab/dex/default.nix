{ lib, config, ... }:
let
  cfg = config.homelab.dex;
  inherit (lib) types;
in
{
  options.homelab.dex = {
    enable = lib.mkEnableOption "dex";

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "dex.${config.homelab.domain}" else null;
      description = "Hostname for dex ingress (defaults to dex.<domain> if domain is set)";
    };

    clientId = lib.mkOption {
      type = types.str;
    };

    clientSecret = lib.mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s = {
      autoDeployCharts.dex = {
        name = "dex";
        repo = "https://charts.dexidp.io";
        version = "0.24.0";
        hash = "sha256-JNSGrCGCuRlIOphAM5mXRDeTzmN+PxDTerMoTqoinTM=";
        targetNamespace = "dex";
        createNamespace = true;

        values = {
          replicaCount = 1;
          https = {
            enabled = false;
          };
          grpc = {
            enabled = false;
          };

          config = {
            issuer = "https://${cfg.ingressHost}";

            storage = {
              type = "kubernetes";
              config = {
                inCluster = true;
              };
            };

            web = {
              http = "0.0.0.0:5556";
            };

            connectors = [
              {
                type = "github";
                id = "github";
                name = "GitHub";
                config = {
                  clientID = "$GITHUB_CLIENT_ID";
                  clientSecret = "$GITHUB_CLIENT_SECRET";
                  redirectURI = "https://${cfg.ingressHost}/callback";
                };
              }
            ];
          };

          envFrom = [
            {
              secretRef = {
                name = "github-client-credentials";
              };
            }
          ];

          configSecret = {
            create = true;
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
                    secretName = "forgejo-tls";
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
            name = "github-client-credentials";
            namespace = "dex";
          };
          stringData = {
            GITHUB_CLIENT_ID = cfg.clientId;
            GITHUB_CLIENT_SECRET = cfg.clientSecret;
          };
        }
      ];
    };
  };
}
