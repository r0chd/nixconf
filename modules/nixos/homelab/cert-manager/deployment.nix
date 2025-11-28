{ config, ... }:
let
  cfg = config.homelab.cert-manager;
in
{
  services.k3s.manifests."cert-manager-deployment".content = [
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "cert-manager-cainjector";
        namespace = "cert-manager";
        labels = {
          app = "cainjector";
          "app.kubernetes.io/name" = "cainjector";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "cainjector";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      spec = {
        replicas = 1;
        selector = {
          matchLabels = {
            "app.kubernetes.io/name" = "cainjector";
            "app.kubernetes.io/instance" = "cert-manager";
            "app.kubernetes.io/component" = "cainjector";
          };
        };
        template = {
          metadata = {
            labels = {
              app = "cainjector";
              "app.kubernetes.io/name" = "cainjector";
              "app.kubernetes.io/instance" = "cert-manager";
              "app.kubernetes.io/component" = "cainjector";
              "app.kubernetes.io/version" = "v1.15.3";
            };
            annotations."reloader.stakater.com/auto" = "true";
          };
          spec = {
            serviceAccountName = "cert-manager-cainjector";
            enableServiceLinks = false;
            securityContext = {
              runAsNonRoot = true;
              seccompProfile = {
                type = "RuntimeDefault";
              };
            };
            containers = [
              {
                name = "cert-manager-cainjector";
                image = "quay.io/jetstack/cert-manager-cainjector:v1.15.3";
                imagePullPolicy = "IfNotPresent";
                args = [
                  "--v=2"
                  "--leader-election-namespace=kube-system"
                ];
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                ];
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  readOnlyRootFilesystem = true;
                };
                inherit (cfg.injector) resources;
              }
            ];
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
          };
        };
      };
    }
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "cert-manager";
        namespace = "cert-manager";
        labels = {
          app = "cert-manager";
          "app.kubernetes.io/name" = "cert-manager";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      spec = {
        replicas = 1;
        selector = {
          matchLabels = {
            "app.kubernetes.io/name" = "cert-manager";
            "app.kubernetes.io/instance" = "cert-manager";
            "app.kubernetes.io/component" = "controller";
          };
        };
        template = {
          metadata = {
            labels = {
              app = "cert-manager";
              "app.kubernetes.io/name" = "cert-manager";
              "app.kubernetes.io/instance" = "cert-manager";
              "app.kubernetes.io/component" = "controller";
              "app.kubernetes.io/version" = "v1.15.3";
            };
            annotations = {
              "prometheus.io/path" = "/metrics";
              "prometheus.io/scrape" = "true";
              "prometheus.io/port" = "9402";
              "reloader.stakater.com/auto" = "true";
            };
          };
          spec = {
            serviceAccountName = "cert-manager";
            enableServiceLinks = false;
            securityContext = {
              runAsNonRoot = true;
              seccompProfile = {
                type = "RuntimeDefault";
              };
            };
            containers = [
              {
                name = "cert-manager-controller";
                image = "quay.io/jetstack/cert-manager-controller:v1.15.3";
                imagePullPolicy = "IfNotPresent";
                args = [
                  "--v=2"
                  "--cluster-resource-namespace=$(POD_NAMESPACE)"
                  "--leader-election-namespace=kube-system"
                  "--acme-http01-solver-image=quay.io/jetstack/cert-manager-acmesolver:v1.15.3"
                  "--max-concurrent-challenges=60"
                ];
                ports = [
                  {
                    containerPort = 9402;
                    name = "http-metrics";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 9403;
                    name = "http-healthz";
                    protocol = "TCP";
                  }
                ];
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  readOnlyRootFilesystem = true;
                };
                inherit (cfg.controller) resources;
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                ];
                livenessProbe = {
                  httpGet = {
                    port = "http-healthz";
                    path = "/livez";
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  timeoutSeconds = 15;
                  successThreshold = 1;
                  failureThreshold = 8;
                };
              }
            ];
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
          };
        };
      };
    }
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "cert-manager-webhook";
        namespace = "cert-manager";
        labels = {
          app = "webhook";
          "app.kubernetes.io/name" = "webhook";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "webhook";
          "app.kubernetes.io/version" = "v1.15.3";
        };
      };
      spec = {
        replicas = 1;
        selector = {
          matchLabels = {
            "app.kubernetes.io/name" = "webhook";
            "app.kubernetes.io/instance" = "cert-manager";
            "app.kubernetes.io/component" = "webhook";
          };
        };
        template = {
          metadata = {
            labels = {
              app = "webhook";
              "app.kubernetes.io/name" = "webhook";
              "app.kubernetes.io/instance" = "cert-manager";
              "app.kubernetes.io/component" = "webhook";
              "app.kubernetes.io/version" = "v1.15.3";
            };
            annotations."reloader.stakater.com/auto" = "true";
          };
          spec = {
            serviceAccountName = "cert-manager-webhook";
            enableServiceLinks = false;
            securityContext = {
              runAsNonRoot = true;
              seccompProfile = {
                type = "RuntimeDefault";
              };
            };
            containers = [
              {
                name = "cert-manager-webhook";
                image = "quay.io/jetstack/cert-manager-webhook:v1.15.3";
                imagePullPolicy = "IfNotPresent";
                args = [
                  "--v=2"
                  "--secure-port=10250"
                  "--dynamic-serving-ca-secret-namespace=$(POD_NAMESPACE)"
                  "--dynamic-serving-ca-secret-name=cert-manager-webhook-ca"
                  "--dynamic-serving-dns-names=cert-manager-webhook"
                  "--dynamic-serving-dns-names=cert-manager-webhook.$(POD_NAMESPACE)"
                  "--dynamic-serving-dns-names=cert-manager-webhook.$(POD_NAMESPACE).svc"
                ];
                ports = [
                  {
                    name = "https";
                    protocol = "TCP";
                    containerPort = 10250;
                  }
                  {
                    name = "healthcheck";
                    protocol = "TCP";
                    containerPort = 6080;
                  }
                ];
                livenessProbe = {
                  httpGet = {
                    path = "/livez";
                    port = 6080;
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 60;
                  periodSeconds = 10;
                  timeoutSeconds = 1;
                  successThreshold = 1;
                  failureThreshold = 3;
                };
                readinessProbe = {
                  httpGet = {
                    path = "/healthz";
                    port = 6080;
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 5;
                  periodSeconds = 5;
                  timeoutSeconds = 1;
                  successThreshold = 1;
                  failureThreshold = 3;
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  readOnlyRootFilesystem = true;
                };
                inherit (cfg.webhook) resources;
                env = [
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                ];
              }
            ];
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
          };
        };
      };
    }
  ];
}
