{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.homelab.vaultwarden;
in
{
  imports = [ ./db.nix ];

  options.homelab.vaultwarden = {
    enable = lib.mkEnableOption "vaultwarden";
    replicas = lib.mkOption {
      type = types.int;
      default = 1;
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "vaultwarden.${config.homelab.domain}" else null;
      description = "Hostname for vaultwarden ingress (defaults to vaultwarden.<domain> if domain is set)";
    };

    accessKeyId = lib.mkOption {
      type = types.str;
    };

    secretAccessKey = lib.mkOption {
      type = types.str;
    };
  };

  config.services.k3s = lib.mkIf cfg.enable {
    autoDeployCharts.vaultwarden = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://guerzon.github.io/vaultwarden";
        chart = "vaultwarden";
        version = "0.34.4";
        chartHash = "sha256-qn2kfuXoLqHLyacYrBwvKgVb+qZjMu+E16dq9jJS3RE=";
      };
      targetNamespace = "vaultwarden";
      createNamespace = true;

      values = {
        inherit (cfg) replicas;

        serviceAccount = {
          create = true;
          name = "vaultwarden-svc";
        };

        webVaultEnabled = true;

        database = {
          type = "postgresql";
          existingSecret = "vaultwarden-db-app";
          existingSecretKey = "uri";
          connectionRetries = 30;
        };

        domain = if cfg.ingressHost != null then "https://${cfg.ingressHost}" else "https://localhost";

        # TODO: once I get a yubikey
        #yubico = lib.mkIf cfg.yubikey.enable {
        #  clientId = 112701;
        #  existingSecret = "yubisecret";
        #  secretKey.existingSecretKey = "YUBI";
        #};

        ingress =
          if cfg.ingressHost != null then
            {
              enabled = true;
              class = "nginx";
              nginxIngressAnnotations = true;
              additionalAnnotations = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                "cert-manager.io/cluster-issuer" = "letsencrypt";
              };
              labels = { };
              tls = true;
              hostname = cfg.ingressHost;
              path = "/";
              pathType = "Prefix";
              tlsSecret = "vaultwarden-tls";
            }
          else
            { };
      };
    };

    secrets = [
      {
        metadata = {
          name = "garage-s3-credentials";
          namespace = "vaultwarden";
        };
        stringData = {
          access-key = cfg.accessKeyId;
          secret-key = cfg.secretAccessKey;
        };
      }
    ];

    #secrets = lib.mkIf cfg.yubikey.enable [
    #  {
    #    name = "yubisecret";
    #    namespace = "vaultwarden";
    #    data.YUBI = cfg.yubikey.keyFile;
    #  }
    #];
  };
}
