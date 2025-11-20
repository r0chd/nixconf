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
        alphaConfig = {
          enabled = false;
          annotations = { };
          serverConfigData = { };
          metricsConfigData = { };
          configData = { };
          configFile = "";
          existingConfig = null;
          existingSecret = null;
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
        };
        extraEnv = [ ];

        envFrom = [
          {
            secretRef = {
              name = "oauth2-proxy-cookie";
            };
          }
          {
            secretRef = {
              name = "dex-oauth2-client-secret";
            };
          }
        ];

        customLabels = { };
        authenticatedEmailsFile = {
          enabled = false;
          persistence = "configmap";
          template = "";
          restrictedUserAccessKey = "";
          restricted_access = "";
          annotations = { };
        };
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
              annotations = {
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
        resources = { };
        resizePolicy = [ ];
        extraVolumes = [ ];
        extraVolumeMounts = [ ];
        extraContainers = [ ];
        extraInitContainers = [ ];
        priorityClassName = "";
        hostAliases = [ ];
        tolerations = [ ];
        nodeSelector = { };
        proxyVarsAsSecrets = false;
        livenessProbe = {
          enabled = true;
          initialDelaySeconds = 0;
          timeoutSeconds = 1;
        };
        readinessProbe = {
          enabled = true;
          initialDelaySeconds = 0;
          timeoutSeconds = 5;
          periodSeconds = 10;
          successThreshold = 1;
        };
        securityContext = {
          enabled = true;
          allowPrivilegeEscalation = false;
          capabilities = {
            drop = [ "ALL" ];
          };
          readOnlyRootFilesystem = true;
          runAsNonRoot = true;
          runAsUser = 2000;
          runAsGroup = 2000;
          seccompProfile = {
            type = "RuntimeDefault";
          };
        };
        deploymentAnnotations = { };
        podAnnotations = { };
        podLabels = { };
        replicaCount = 1;
        revisionHistoryLimit = 10;
        strategy = { };
        enableServiceLinks = true;
        podDisruptionBudget = {
          enabled = true;
          maxUnavailable = null;
          minAvailable = 1;
          unhealthyPodEvictionPolicy = "";
        };
        autoscaling = {
          enabled = false;
          minReplicas = 1;
          maxReplicas = 10;
          targetCPUUtilizationPercentage = 80;
          annotations = { };
          behavior = { };
        };
        podSecurityContext = { };
        httpScheme = "http";
        initContainers = {
          waitForRedis = {
            enabled = true;
            image = {
              repository = "alpine";
              tag = "latest";
              pullPolicy = "IfNotPresent";
            };
            kubectlVersion = "";
            securityContext = {
              enabled = true;
              allowPrivilegeEscalation = false;
              capabilities = {
                drop = [ "ALL" ];
              };
              readOnlyRootFilesystem = true;
              runAsNonRoot = true;
              runAsUser = 65534;
              runAsGroup = 65534;
              seccompProfile = {
                type = "RuntimeDefault";
              };
            };
            timeout = 180;
            resources = { };
          };
        };
        htpasswdFile = {
          enabled = false;
          existingSecret = "";
          entries = [ ];
        };
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
        metrics = {
          enabled = true;
          port = 44180;
          service = {
            appProtocol = "http";
          };
          serviceMonitor = {
            enabled = false;
            namespace = "";
            prometheusInstance = "default";
            interval = "60s";
            scrapeTimeout = "30s";
            labels = { };
            scheme = "";
            tlsConfig = { };
            bearerTokenFile = "";
            annotations = { };
            metricRelabelings = [ ];
            relabelings = [ ];
          };
        };
        extraObjects = [ ];
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
        resources = {
          requests = {
            cpu = "500m";
            memory = "500Mi";
          };
          limits = {
            cpu = "600m";
            memory = "750Mi";
          };
        };
      };
    };
  };
}
