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
  options.homelab.vaultwarden = {
    enable = lib.mkEnableOption "vaultwarden";
    hostname = lib.mkOption { type = types.str; };
    replicas = lib.mkOption {
      type = types.int;
      default = 1;
    };
    storage = lib.mkOption { type = types.str; };
    yubikey = {
      enable = lib.mkEnableOption "yubikey auth";
      keyFile = lib.mkOption { type = types.path; };
    };
  };

  config.services.k3s = lib.mkIf cfg.enable {
    autoDeployCharts.vaultwarden = {
      package = pkgs.lib.downloadHelmChart {
        repo = "https://guerzon.github.io/vaultwarden";
        chart = "vaultwarden";
        version = "0.32.1";
        chartHash = "sha256-tseCtu9MZxVHmqvlIg67WYQvPtKDk+L0rodoIIcWYnU=";
      };
      targetNamespace = "vaultwarden";
      createNamespace = true;

      values = {
        image = {
          registry = "docker.io";
          repository = "vaultwarden/server";
          tag = "1.34.1-alpine";
          pullPolicy = "IfNotPresent";
          pullSecrets = [ ];
          extraSecrets = [ ];
          extraVars = [ ];
          extraVarsCM = "";
          extraVarsSecret = "";

          inherit (cfg) replicas;
          fullnameOverride = "";
          resourceType = "";
          commonAnnotations = { };
          configMapAnnotations = { };
          podAnnotations = { };
          commonLabels = { };
          podLabels = { };
          initContainers = [ ];
          sidecars = [ ];
          nodeSelector = { };
          affinity = { };
          tolerations = [ ];

          serviceAccount = {
            create = true;
            name = "vaultwarden-svc";
          };

          podSecurityContext = { };
          securityContext = { };
          dnsConfig = { };
          enableServiceLinks = true;

          livenessProbe = {
            enabled = true;
            initialDelaySeconds = 5;
            timeoutSeconds = 1;
            periodSeconds = 10;
            successThreshold = 1;
            failureThreshold = 10;
            path = "/alive";
          };

          readinessProbe = {
            enabled = true;
            initialDelaySeconds = 5;
            timeoutSeconds = 1;
            periodSeconds = 10;
            successThreshold = 1;
            failureThreshold = 3;
            path = "/alive";
          };

          startupProbe = {
            enabled = false;
            initialDelaySeconds = 5;
            timeoutSeconds = 1;
            periodSeconds = 10;
            successThreshold = 1;
            failureThreshold = 10;
            path = "/alive";
          };

          resources = { };
          strategy = { };

          podDistruptionBudget = {
            enabled = false;
            minAvailable = 1;
            maxUnavailable = null;
          };

          storage = {
            existingVolumeClaim = { };
            data = { };
            attachments = { };
          };

          webVaultEnabled = true;

          database = {
            type = "default";
            host = "";
            port = "";
            username = "";
            password = "";
            dbName = "";
            uriOverride = "";
            existingSecret = "";
            existingSecretKey = "";
            connectionRetries = 15;
            maxConnections = 10;
          };

          pushNotifications = {
            enabled = false;
            existingSecret = "";
            installationId = {
              value = "";
              existingSecretKey = "";
            };
            installationKey = {
              value = "";
              existingSecretKey = "";
            };
            relayUri = "https://push.bitwarden.com";
            identityUri = "https://identity.bitwarden.com";
          };

          emergencyNotifReminderSched = "0 3 * * * *";
          emergencyRqstTimeoutSched = "0 7 * * * *";
          eventCleanupSched = "0 10 0 * * *";
          eventsDayRetain = "";
          domain = "https://vaultwarden.your-domain.com";
          sendsAllowed = true;
          hibpApiKey = "";
          orgAttachmentLimit = "";
          userAttachmentLimit = "";
          userSendLimit = "";
          trashAutoDeleteDays = "";
          signupsAllowed = true;
          signupsVerify = true;
          signupDomains = "";
          orgEventsEnabled = false;
          orgCreationUsers = "";
          invitationsAllowed = true;
          invitationOrgName = "Vaultwarden";
          invitationExpirationHours = "120";
          emergencyAccessAllowed = true;
          emailChangeAllowed = true;
          showPassHint = false;
          ipHeader = "X-Real-IP";
          iconService = "internal";
          iconRedirectCode = "302";
          iconBlacklistNonGlobalIps = true;
          experimentalClientFeatureFlags = null;
          requireDeviceEmail = false;
          extendedLogging = true;
          logTimestampFormat = "%Y-%m-%d %H:%M:%S.%3f";

          logging = {
            logLevel = "";
            logFile = "";
          };

          adminToken = {
            existingSecret = "";
            existingSecretKey = "";
            value = "$argon2id$v=19$m=19456,t=2,p=1$Vkx1VkE4RmhDMUhwNm9YVlhPQkVOZk1Yc1duSDdGRVYzd0Y5ZkgwaVg0Yz0$PK+h1ANCbzzmEKaiQfCjWw+hWFaMKvLhG2PjRanH5Kk";
          };

          adminRateLimitSeconds = "300";
          adminRateLimitMaxBurst = "3";
          timeZone = "";
          orgGroupsEnabled = false;

          yubico = lib.mkIf cfg.yubikey.enable {
            clientId = 112701;
            existingSecret = "yubisecret";
            secretKey.existingSecretKey = "YUBI";
          };

          duo = {
            iKey = "";
            existingSecret = "";
            sKey = {
              value = "";
              existingSecretKey = "";
            };
            hostname = "";
          };

          smtp = {
            existingSecret = "";
            host = "";
            security = "starttls";
            port = 25;
            from = "";
            fromName = "";
            username = {
              value = "";
              existingSecretKey = "";
            };
            password = {
              value = "";
              existingSecretKey = "";
            };
            authMechanism = "Plain";
            acceptInvalidHostnames = "false";
            acceptInvalidCerts = "false";
            debug = false;
          };

          rocket = {
            address = "0.0.0.0";
            port = "8080";
            workers = "10";
            service = {
              type = "ClusterIP";
              annotations = { };
              labels = { };
              ipFamilyPolicy = "SingleStack";
              sessionAffinity = "";
              sessionAffinityConfig = { };
            };
          };

          ingress = {
            enabled = true;
            class = "ingress-nginx";
            nginxIngressAnnotations = true;
            additionalAnnotations = { };
            labels = { };
            tls = true;
            inherit (cfg) hostname;
            additionalHostnames = [ ];
            path = "/";
            pathType = "Prefix";
            tlsSecret = "";
            nginxAllowList = "";
            customHeadersConfigMap = { };
          };
        };
      };

      extraDeploy = [
        {
          apiVersion = "v1";
          kind = "PersistentVolumeClaim";
          metadata = {
            name = "vaultwarden-data";
            namespace = "vaultwarden";
          };
          spec = {
            accessModes = [ "ReadWriteOnce" ];
            storageClassName = "openebs-hostpath";
            resources.requests.storage = cfg.storage;
          };
        }
      ];
    };
    secrets = lib.mkIf cfg.yubikey.enable [
      {
        name = "yubisecret";
        namespace = "vaultwarden";
        data.YUBI = cfg.yubikey.keyFile;
      }
    ];
  };
}
