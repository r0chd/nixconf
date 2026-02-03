{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.auth.oauth2-proxy;
  inherit (lib) types;
in
{
  options.homelab.auth.oauth2-proxy = {
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "oauth2-proxy.${config.homelab.domain}" else null;
      description = "Hostname for oauth2-proxy ingress (defaults to oauth2-proxy.<domain> if domain is set)";
    };

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Kubernetes resource requests/limits for the oauth2-proxy container.";
    };
  };

  config.services.k3s = lib.mkIf config.homelab.auth.enable {
    autoDeployCharts.oauth2-proxy = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://oauth2-proxy.github.io/manifests";
        chart = "oauth2-proxy";
        version = "8.3.3";
        chartHash = "sha256-zE2PO/tL68spXRtyd4ZVvDlFDnfc+hVP3sdgjkwPToc=";
      };
      targetNamespace = "auth";

      values = {
        global = { };
        kubeVersion = null;
        config = {
          existingSecret = "oauth2-proxy-credentials";
          configFile = ''
            provider = "oidc"
            oidc_issuer_url = "https://${config.homelab.auth.dex.ingressHost}"

            client_id = "oauth2-proxy"

            redirect_url = "https://${cfg.ingressHost}/oauth2/callback"
            cookie_secure = "true"
            cookie_domains = [".${config.homelab.domain}"]
            whitelist_domains = [".${config.homelab.domain}"]
            email_domains = ["*"]
            upstreams = ["file:///dev/null"]
            set_xauthrequest = true
          '';
        };
        image = {
          repository = "quay.io/oauth2-proxy/oauth2-proxy";
          tag = "";
          pullPolicy = "IfNotPresent";
          command = [ ];
        };
        imagePullSecrets = [ ];
        extraArgs = {
          reverse-proxy = true;
          ssl-insecure-skip-verify = true;
        };
        extraEnv = [ ];

        envFrom = [ ];

        service = {
          type = "ClusterIP";
          portNumber = 80;
          appProtocol = "http";
          annotations = { };
          externalTrafficPolicy = "";
          internalTrafficPolicy = "";
          targetPort = "";
          ipDualStack = {
            enabled = false;
            ipFamilies = [
              "IPv6"
              "IPv4"
            ];
            ipFamilyPolicy = "PreferDualStack";
          };
          trafficDistribution = "";
        };
        serviceAccount = {
          enabled = true;
          name = null;
          automountServiceAccountToken = true;
          annotations = { };
        };
        networkPolicy = {
          create = false;
          ingress = [ ];
          egress = [ ];
        };
        ingress =
          if cfg.ingressHost != null then
            {
              enabled = true;
              className = "nginx";
              annotations = lib.optionalAttrs config.homelab.cert-manager.enable {
                "cert-manager.io/cluster-issuer" = "letsencrypt";
              };
              path = "/";
              hosts = [ cfg.ingressHost ];
              tls = [
                {
                  secretName = "oauth2-proxy-tls";
                  hosts = [ cfg.ingressHost ];
                }
              ];
            }
          else
            { };
        inherit (cfg) resources;
        sessionStorage = {
          type = "redis";
          redis = {
            clientType = "standalone";
            standalone = {
              connectionUrl = "redis://oauth2-proxy-dragonfly.auth.svc.cluster.local:6379";
            };
            password = "";
            passwordKey = "redis-password";
          };
        };
        redis = {
          enabled = false;
        };
        checkDeprecation = true;
      };
    };

    manifests.oauth2-proxy-dragonfly.content = {
      apiVersion = "dragonflydb.io/v1alpha1";
      kind = "Dragonfly";
      metadata = {
        name = "oauth2-proxy-dragonfly";
        namespace = "auth";
      };
      spec = {
        replicas = 1;
        args = [
          "--proactor_threads=1"
        ];
        resources = {
          requests = {
            cpu = "500m";
            memory = "256Mi";
          };
          limits = {
            memory = "384Mi";
          };
        };
      };
    };
  };
}
