{ config, ... }:
let
  cfg = config.homelab.ingress;
in
{
  services.k3s.manifests.ingress-nginx-deployment.content = [
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/component" = "controller";
        };
        name = "ingress-nginx-controller";
        namespace = "ingress-nginx";
      };
      spec = {
        selector = {
          matchLabels = {
            "app.kubernetes.io/name" = "ingress-nginx";
            "app.kubernetes.io/instance" = "ingress-nginx";
            "app.kubernetes.io/component" = "controller";
          };
        };
        replicas = 1;
        revisionHistoryLimit = 10;
        minReadySeconds = 0;
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/instance" = "ingress-nginx";
              "app.kubernetes.io/version" = "1.14.0";
              "app.kubernetes.io/part-of" = "ingress-nginx";
              "app.kubernetes.io/component" = "controller";
            };
          };
          spec = {
            dnsPolicy = "ClusterFirst";
            containers = [
              {
                name = "controller";
                image = "registry.k8s.io/ingress-nginx/controller:v1.14.0@sha256:e4127065d0317bd11dc64c4dd38dcf7fb1c3d72e468110b4086e636dbaac943d";
                imagePullPolicy = "IfNotPresent";
                lifecycle = {
                  preStop = {
                    exec = {
                      command = [ "/wait-shutdown" ];
                    };
                  };
                };
                args = [
                  "/nginx-ingress-controller"
                  "--publish-service=$(POD_NAMESPACE)/ingress-nginx-controller"
                  "--election-id=ingress-nginx-leader"
                  "--controller-class=k8s.io/ingress-nginx"
                  "--ingress-class=nginx"
                  "--configmap=$(POD_NAMESPACE)/ingress-nginx-controller"
                  "--validating-webhook=:8443"
                  "--validating-webhook-certificate=/usr/local/certificates/cert"
                  "--validating-webhook-key=/usr/local/certificates/key"
                ];
                securityContext = {
                  runAsNonRoot = true;
                  runAsUser = 101;
                  runAsGroup = 82;
                  allowPrivilegeEscalation = false;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                  capabilities = {
                    drop = [ "ALL" ];
                    add = [ "NET_BIND_SERVICE" ];
                  };
                  readOnlyRootFilesystem = false;
                };
                env = [
                  {
                    name = "POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                  {
                    name = "POD_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                  {
                    name = "LD_PRELOAD";
                    value = "/usr/local/lib/libmimalloc.so";
                  }
                ];
                livenessProbe = {
                  failureThreshold = 5;
                  httpGet = {
                    path = "/healthz";
                    port = 10254;
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 1;
                };
                readinessProbe = {
                  failureThreshold = 3;
                  httpGet = {
                    path = "/healthz";
                    port = 10254;
                    scheme = "HTTP";
                  };
                  initialDelaySeconds = 10;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 1;
                };
                ports = [
                  {
                    name = "http";
                    containerPort = 80;
                    protocol = "TCP";
                  }
                  {
                    name = "https";
                    containerPort = 443;
                    protocol = "TCP";
                  }
                  {
                    name = "webhook";
                    containerPort = 8443;
                    protocol = "TCP";
                  }
                ];
                volumeMounts = [
                  {
                    name = "webhook-cert";
                    mountPath = "/usr/local/certificates/";
                    readOnly = true;
                  }
                ];
                inherit (cfg) resources;
              }
            ];
            hostNetwork = true;
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
            serviceAccountName = "ingress-nginx";
            automountServiceAccountToken = true;
            terminationGracePeriodSeconds = 300;
            volumes = [
              {
                name = "webhook-cert";
                secret = {
                  secretName = "ingress-nginx-admission";
                };
              }
            ];
          };
        };
      };
    }
  ];
}
