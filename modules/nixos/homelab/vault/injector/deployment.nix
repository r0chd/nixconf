{ config, lib, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.vault.enable) {
    services.k3s.manifests."vault-injector-deployment".content = [
      {
        apiVersion = "apps/v1";
        kind = "Deployment";
      metadata = {
        name = "vault-agent-injector-svc";
        namespace = "vault";
        labels = {
          "app.kubernetes.io/name" = "vault-agent-injector";
          "app.kubernetes.io/instance" = "vault";
          component = "webhook";
        };
      };
      spec = {
        replicas = 1;
        selector.matchLabels = {
          "app.kubernetes.io/name" = "vault-agent-injector";
          "app.kubernetes.io/instance" = "vault";
          component = "webhook";
        };
        template = {
          metadata.labels = {
            "app.kubernetes.io/name" = "vault-agent-injector";
            "app.kubernetes.io/instance" = "vault";
            component = "webhook";
          };
          spec = {
            serviceAccountName = "vault-agent-injector";
            containers = [
              {
                name = "sidecar-injector";
                resources = {
                  limits = {
                    cpu = "250m";
                    memory = "256Mi";
                  };
                  requests = {
                    cpu = "250m";
                    memory = "256Mi";
                  };
                };
                image = "hashicorp/vault-k8s:1.3.0";
                imagePullPolicy = "IfNotPresent";
                env = [
                  {
                    name = "AGENT_INJECT_LISTEN";
                    value = ":8080";
                  }
                  {
                    name = "AGENT_INJECT_LOG_LEVEL";
                    value = "info";
                  }
                  {
                    name = "AGENT_INJECT_VAULT_ADDR";
                    value = "http://vault.vault.svc:8200";
                  }
                  {
                    name = "AGENT_INJECT_VAULT_IMAGE";
                    value = "hashicorp/vault:1.16.0";
                  }
                  {
                    name = "AGENT_INJECT_TLS_AUTO";
                    value = "vault-agent-injector-cfg";
                  }
                  {
                    name = "AGENT_INJECT_TLS_AUTO_HOSTS";
                    value = "vault-agent-injector-svc,vault-agent-injector-svc.vault,vault-agent-injector-svc.vault.svc";
                  }
                  {
                    name = "AGENT_INJECT_MEM_TEMPLATE";
                    value = "64Mi";
                  }
                ];
                args = [ "agent-inject" ];
                startupProbe = {
                  tcpSocket = {
                    port = 8080;
                  };
                  failureThreshold = 30;
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
                livenessProbe = {
                  tcpSocket = {
                    port = 8080;
                  };
                  failureThreshold = 3;
                  initialDelaySeconds = 30;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
                readinessProbe = {
                  tcpSocket = {
                    port = 8080;
                  };
                  failureThreshold = 3;
                  initialDelaySeconds = 30;
                  periodSeconds = 5;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
              }
            ];
          };
        };
      };
    }
    ];
  };
}
