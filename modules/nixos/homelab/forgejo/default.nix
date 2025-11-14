{ lib, config, ... }:
let
  cfg = config.homelab.forgejo;
  inherit (lib) types;
in
{
  options.homelab.forgejo = {
    enable = lib.mkEnableOption "forgejo";
    ingressHost = lib.mkOption {
      type = types.nullOr types.str;
      default = if config.homelab.domain != null then "forgejo.${config.homelab.domain}" else null;
      description = "Hostname for forgejo ingress (defaults to forgejo.<domain> if domain is set)";
    };
  };

  config = lib.mkIf cfg.enable {
    autoDeployCharts.quickwit = {
      name = "forgejo";
      repo = "oci://code.forgejo.org/forgejo-helm/forgejo";
      version = "15.0.2";
      hash = "sha256-bDW/o15coCO1iys5fw87zyXTLDK5mtfnii09121tvJk=";
      targetNamespace = "forgejo";
      createNamespace = true;

      values = {
        global = {
          imageRegistry = "";
          imagePullSecrets = [ ];
          storageClass = "";
          hostAliases = [ ];
        };
        replicaCount = 1;
        strategy = {
          type = "RollingUpdate";
          rollingUpdate = {
            maxSurge = "100%";
            maxUnavailable = 0;
          };
        };
        clusterDomain = "cluster.local";
        image = {
          registry = "code.forgejo.org";
          repository = "forgejo/forgejo";
          tag = "";
          digest = "";
          pullPolicy = "IfNotPresent";
          rootless = true;
          fullOverride = "";
        };
        imagePullSecrets = [ ];
        podSecurityContext = {
          fsGroup = 1000;
        };
        containerSecurityContext = { };
        securityContext = { };
        podDisruptionBudget = { };
        service = {
          http = {
            type = "ClusterIP";
            port = 3000;
            clusterIP = null;
            loadBalancerIP = null;
            nodePort = null;
            externalTrafficPolicy = null;
            externalIPs = null;
            ipFamilyPolicy = null;
            ipFamilies = null;
            loadBalancerSourceRanges = [ ];
            annotations = { };
            labels = { };
            loadBalancerClass = null;
            extraPorts = [ ];
          };
          ssh = {
            type = "ClusterIP";
            port = 22;
            clusterIP = null;
            loadBalancerIP = null;
            nodePort = null;
            externalTrafficPolicy = null;
            externalIPs = null;
            ipFamilyPolicy = null;
            ipFamilies = null;
            hostPort = null;
            loadBalancerSourceRanges = [ ];
            annotations = { };
            labels = { };
            loadBalancerClass = null;
          };
        };
        ingress =
          if cfg.ingressHost != null then
            {
              enabled = true;
              ingressClassName = "nginx";
              annotations = {
                "nginx.ingress.kubernetes.io/rewrite-target" = "/";
                "cert-manager.io/cluster-issuer" = "letsencrypt";
              };
              hosts = [
                {
                  host = cfg.ingressHost;
                  paths = [
                    {
                      path = "/";
                      pathType = "Prefix";
                      port = "http";
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

        httpRoute = {
          enabled = false;
          annotations = { };
          parentRefs = [ ];
          hostnames = [ ];
          matches = {
            path = {
              type = "PathPrefix";
              value = "/";
            };
            timeouts = { };
          };
          filters = [ ];
        };

        route = {
          enabled = false;
          annotations = { };
          host = null;
          wildcardPolicy = null;
          tls = {
            termination = "edge";
            insecureEdgeTerminationPolicy = "Redirect";
            existingSecret = null;
            certificate = null;
            privateKey = null;
            caCertificate = null;
            destinationCACertificate = null;
          };
        };

        resources = { };
        schedulerName = "";
        nodeSelector = { };
        tolerations = [ ];
        affinity = { };
        topologySpreadConstraints = [ ];
        dnsConfig = { };
        priorityClassName = "";
        deployment = {
          env = [ ];
          terminationGracePeriodSeconds = 60;
          labels = { };
          annotations = { };
        };
        serviceAccount = {
          create = false;
          name = "";
          automountServiceAccountToken = false;
          imagePullSecrets = [ ];
          annotations = { };
          labels = { };
        };
        persistence = {
          enabled = true;
          create = true;
          mount = true;
          claimName = "gitea-shared-storage";
          size = "10Gi";
          accessModes = [ "ReadWriteOnce" ];
          labels = { };
          storageClass = null;
          subPath = null;
          volumeName = "";
          annotations = {
            "helm.sh/resource-policy" = "keep";
          };
        };
        extraContainers = [ ];
        extraVolumes = [ ];
        extraContainerVolumeMounts = [ ];
        extraInitVolumeMounts = [ ];
        extraVolumeMounts = [ ];
        initPreScript = "";
        initContainers = {
          resources = {
            limits = { };
            requests = {
              cpu = "100m";
              memory = "128Mi";
            };
          };
        };
        signing = {
          enabled = false;
          gpgHome = "/data/git/.gnupg";
          privateKey = "";
          existingSecret = "";
        };
        gitea = {
          admin = {
            existingSecret = null;
            username = "gitea_admin";
            password = "";
            email = "gitea@local.domain";
            passwordMode = "keepUpdated";
          };
          metrics = {
            enabled = false;
            serviceMonitor = {
              enabled = false;
              namespace = "";
            };
          };
          ldap = [ ];
          oauth = [ ];
          additionalConfigSources = [ ];
          additionalConfigFromEnvs = [ ];
          podAnnotations = { };
          ssh = {
            logLevel = "INFO";
          };
          config = {
            APP_NAME = "Forgejo: Beyond coding. We forge.";
            RUN_MODE = "prod";
            repository = { };
            cors = { };
            ui = { };
            markdown = { };
            server = {
              SSH_PORT = 22;
              SSH_LISTEN_PORT = 2222;
            };
            database = { };
            indexer = { };
            queue = { };
            admin = { };
            security = { };
            camo = { };
            openid = { };
            oauth2_client = { };
            service = { };
            "ssh.minimum_key_sizes" = { };
            webhook = { };
            mailer = { };
            "email.incoming" = { };
            cache = { };
            session = { };
            picture = { };
            project = { };
            attachment = { };
            log = { };
            cron = { };
            git = { };
            metrics = { };
            api = { };
            oauth2 = { };
            i18n = { };
            markup = { };
            "highlight.mapping" = { };
            time = { };
            migrations = { };
            federation = { };
            packages = { };
            mirror = { };
            lfs = { };
            repo-avatar = { };
            avatar = { };
            storage = { };
            proxy = { };
            actions = { };
            other = { };
          };
          livenessProbe = {
            enabled = true;
            tcpSocket = {
              port = "http";
            };
            initialDelaySeconds = 200;
            timeoutSeconds = 1;
            periodSeconds = 10;
            successThreshold = 1;
            failureThreshold = 10;
          };
          readinessProbe = {
            enabled = true;
            httpGet = {
              path = "/api/healthz";
              port = "http";
            };
            initialDelaySeconds = 5;
            timeoutSeconds = 1;
            periodSeconds = 10;
            successThreshold = 1;
            failureThreshold = 3;
          };
          startupProbe = {
            enabled = false;
            tcpSocket = {
              port = "http";
            };
            initialDelaySeconds = 60;
            timeoutSeconds = 1;
            periodSeconds = 10;
            successThreshold = 1;
            failureThreshold = 10;
          };
        };
        checkDeprecation = true;
        test = {
          enabled = true;
          image = {
            name = "busybox";
            tag = "latest";
          };
        };
        extraDeploy = [ ];
      };
    };
  };
}
