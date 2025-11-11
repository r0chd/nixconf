{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts.immich = {
    package = pkgs.lib.downloadHelmChart {
      repo = "https://oauth2-proxy.github.io/manifests";
      chart = "oauth2-proxy";
      version = "8.3.3";
      chartHash = "";
    };
    targetNamespace = "system";

    values = {
      global = { };
      kubeVersion = null;
      config = {
        annotations = { };
        clientID = "XXXXXXX";
        clientSecret = "XXXXXXXX";
        cookieSecret = "XXXXXXXXXXXXXXXX";
        cookieName = "";
        google = { };
        configFile = "email_domains = [ \"*\" ]\nupstreams = [ \"file:///dev/null\" ]";
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
      extraArgs = { };
      extraEnv = [ ];
      envFrom = [ ];
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
      ingress = {
        enabled = false;
        path = "/";
        pathType = "ImplementationSpecific";
        labels = { };
      };
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
      proxyVarsAsSecrets = true;
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
        type = "cookie";
        redis = {
          existingSecret = "";
          password = "";
          passwordKey = "redis-password";
          clientType = "standalone";
          standalone = {
            connectionUrl = "";
          };
          cluster = {
            connectionUrls = [ ];
          };
          sentinel = {
            existingSecret = "";
            password = "";
            passwordKey = "redis-sentinel-password";
            masterName = "";
            connectionUrls = [ ];
          };
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
}
