_:
{
  services.k3s.manifests.ingress-nginx-deployment.content = [
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        labels = {
          "app.kubernetes.io/component" = "controller";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
        };
        name = "ingress-nginx-controller";
        namespace = "ingress-nginx";
      };
      spec = {
        minReadySeconds = 0;
        revisionHistoryLimit = 10;
        selector = {
          matchLabels = {
            "app.kubernetes.io/component" = "controller";
            "app.kubernetes.io/instance" = "ingress-nginx";
            "app.kubernetes.io/name" = "ingress-nginx";
          };
        };
        strategy = {
          rollingUpdate = {
            maxUnavailable = 1;
          };
          type = "RollingUpdate";
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "controller";
              "app.kubernetes.io/instance" = "ingress-nginx";
              "app.kubernetes.io/name" = "ingress-nginx";
              "app.kubernetes.io/part-of" = "ingress-nginx";
              "app.kubernetes.io/version" = "1.14.0";
            };
          };
          spec = {
            automountServiceAccountToken = true;
            containers = [
              {
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
                image = "registry.k8s.io/ingress-nginx/controller:v1.14.0@sha256:e4127065d0317bd11dc64c4dd38dcf7fb1c3d72e468110b4086e636dbaac943d";
                imagePullPolicy = "IfNotPresent";
                lifecycle = {
                  preStop = {
                    exec = {
                      command = [ "/wait-shutdown" ];
                    };
                  };
                };
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
                name = "controller";
                ports = [
                  {
                    containerPort = 80;
                    name = "http";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 443;
                    name = "https";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 8443;
                    name = "webhook";
                    protocol = "TCP";
                  }
                ];
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
                resources = {
                  requests = {
                    cpu = "100m";
                    memory = "90Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    add = [ "NET_BIND_SERVICE" ];
                    drop = [ "ALL" ];
                  };
                  readOnlyRootFilesystem = false;
                  runAsGroup = 82;
                  runAsNonRoot = true;
                  runAsUser = 101;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
                volumeMounts = [
                  {
                    mountPath = "/usr/local/certificates/";
                    name = "webhook-cert";
                    readOnly = true;
                  }
                ];
              }
            ];
            dnsPolicy = "ClusterFirst";
            nodeSelector = {
              "kubernetes.io/os" = "linux";
            };
            serviceAccountName = "ingress-nginx";
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
