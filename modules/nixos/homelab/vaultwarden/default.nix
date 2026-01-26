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

    gated = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether to gate this service behind oauth2-proxy";
    };

    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default =
        if config.homelab.domain != null then
          if config.homelab.vaultwarden.gated then
            "vaultwarden.i.${config.homelab.domain}"
          else
            "vaultwarden.${config.homelab.domain}"
        else
          null;
      description = "Hostname for vaultwarden ingress (defaults to vaultwarden.i.<domain> if gated, vaultwarden.<domain> otherwise)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits for vaultwarden container.";
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
              }
              // lib.optionalAttrs config.homelab.cert-manager.enable {
                "cert-manager.io/cluster-issuer" = "letsencrypt";
              }
              // lib.optionalAttrs cfg.gated {
                "nginx.ingress.kubernetes.io/auth-signin" =
                  "https://${config.homelab.auth.oauth2-proxy.ingressHost}/oauth2/start?rd=https://$host$escaped_request_uri";
                "nginx.ingress.kubernetes.io/auth-url" = "http://oauth2-proxy.auth.svc.cluster.local/oauth2/auth";
                "nginx.ingress.kubernetes.io/auth-response-headers" = "X-Auth-Request-User,X-Auth-Request-Email";
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

        inherit (cfg) resources;
      };
    };

    #secrets = lib.mkIf cfg.yubikey.enable [
    #  {
    #    name = "yubisecret";
    #    namespace = "vaultwarden";
    #    data.YUBI = cfg.yubikey.keyFile;
    #  }
    #];
  };
}
