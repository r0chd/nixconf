{ ... }:
{
  services.k3s.manifests."kyverno-deployment".content = [
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "kyverno-admission-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "admission-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      spec = {
        replicas = null;
        revisionHistoryLimit = 10;
        strategy = {
          rollingUpdate = {
            maxSurge = 1;
            maxUnavailable = "40%";
          };
          type = "RollingUpdate";
        };
        selector = {
          matchLabels = {
            "app.kubernetes.io/component" = "admission-controller";
            "app.kubernetes.io/instance" = "kyverno";
            "app.kubernetes.io/part-of" = "kyverno";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "admission-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
              "app.kubernetes.io/version" = "v1.16.1";
            };
          };
          spec = {
            dnsPolicy = "ClusterFirst";
            affinity = {
              podAntiAffinity = {
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    podAffinityTerm = {
                      labelSelector = {
                        matchExpressions = [
                          {
                            key = "app.kubernetes.io/component";
                            operator = "In";
                            values = [ "admission-controller" ];
                          }
                        ];
                      };
                      topologyKey = "kubernetes.io/hostname";
                    };
                    weight = 1;
                  }
                ];
              };
            };
            serviceAccountName = "kyverno-admission-controller";
            automountServiceAccountToken = true;
            initContainers = [
              {
                name = "kyverno-pre";
                image = "reg.kyverno.io/kyverno/kyvernopre:v1.16.1";
                imagePullPolicy = "IfNotPresent";
                args = [
                  "--loggingFormat=text"
                  "--v=2"
                  "--openreportsEnabled=false"
                ];
                resources = {
                  limits = {
                    memory = "256Mi";
                  };
                  requests = {
                    cpu = "10m";
                    memory = "64Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  privileged = false;
                  readOnlyRootFilesystem = true;
                  runAsNonRoot = true;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
                env = [
                  {
                    name = "KYVERNO_SERVICEACCOUNT_NAME";
                    value = "kyverno-admission-controller";
                  }
                  {
                    name = "KYVERNO_ROLE_NAME";
                    value = "kyverno:admission-controller";
                  }
                  {
                    name = "INIT_CONFIG";
                    value = "kyverno";
                  }
                  {
                    name = "METRICS_CONFIG";
                    value = "kyverno-metrics";
                  }
                  {
                    name = "KYVERNO_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_DEPLOYMENT";
                    value = "kyverno-admission-controller";
                  }
                  {
                    name = "KYVERNO_SVC";
                    value = "kyverno-svc";
                  }
                ];
              }
            ];
            containers = [
              {
                name = "kyverno";
                image = "reg.kyverno.io/kyverno/kyverno:v1.16.1";
                imagePullPolicy = "IfNotPresent";
                args = [
                  "--caSecretName=kyverno-svc.kyverno.svc.kyverno-tls-ca"
                  "--tlsSecretName=kyverno-svc.kyverno.svc.kyverno-tls-pair"
                  "--backgroundServiceAccountName=system:serviceaccount:kyverno:kyverno-background-controller"
                  "--reportsServiceAccountName=system:serviceaccount:kyverno:kyverno-reports-controller"
                  "--servicePort=443"
                  "--webhookServerPort=9443"
                  "--resyncPeriod=15m"
                  "--crdWatcher=false"
                  "--disableMetrics=false"
                  "--otelConfig=prometheus"
                  "--metricsPort=8000"
                  "--admissionReports=true"
                  "--maxAdmissionReports=1000"
                  "--autoUpdateWebhooks=true"
                  "--enableConfigMapCaching=true"
                  "--controllerRuntimeMetricsAddress=:8080"
                  "--enableDeferredLoading=true"
                  "--dumpPayload=false"
                  "--forceFailurePolicyIgnore=false"
                  "--generateValidatingAdmissionPolicy=true"
                  "--generateMutatingAdmissionPolicy=false"
                  "--dumpPatches=false"
                  "--maxAPICallResponseLength=2000000"
                  "--loggingFormat=text"
                  "--v=2"
                  "--omitEvents=PolicyApplied,PolicySkipped"
                  "--enablePolicyException=false"
                  "--protectManagedResources=false"
                  "--allowInsecureRegistry=false"
                  "--registryCredentialHelpers=default,google,amazon,azure,github"
                  "--enableReporting=validate,mutate,mutateExisting,imageVerify,generate"
                ];
                resources = {
                  limits = {
                    memory = "384Mi";
                  };
                  requests = {
                    cpu = "100m";
                    memory = "128Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  privileged = false;
                  readOnlyRootFilesystem = true;
                  runAsNonRoot = true;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
                ports = [
                  {
                    containerPort = 9443;
                    name = "https";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 8000;
                    name = "metrics-port";
                    protocol = "TCP";
                  }
                ];
                env = [
                  {
                    name = "INIT_CONFIG";
                    value = "kyverno";
                  }
                  {
                    name = "METRICS_CONFIG";
                    value = "kyverno-metrics";
                  }
                  {
                    name = "KYVERNO_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_SERVICEACCOUNT_NAME";
                    value = "kyverno-admission-controller";
                  }
                  {
                    name = "KYVERNO_ROLE_NAME";
                    value = "kyverno:admission-controller";
                  }
                  {
                    name = "KYVERNO_SVC";
                    value = "kyverno-svc";
                  }
                  {
                    name = "TUF_ROOT";
                    value = "/.sigstore";
                  }
                  {
                    name = "KYVERNO_DEPLOYMENT";
                    value = "kyverno-admission-controller";
                  }
                ];
                startupProbe = {
                  failureThreshold = 20;
                  httpGet = {
                    path = "/health/liveness";
                    port = 9443;
                    scheme = "HTTPS";
                  };
                  initialDelaySeconds = 2;
                  periodSeconds = 6;
                };
                livenessProbe = {
                  failureThreshold = 2;
                  httpGet = {
                    path = "/health/liveness";
                    port = 9443;
                    scheme = "HTTPS";
                  };
                  initialDelaySeconds = 15;
                  periodSeconds = 30;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
                readinessProbe = {
                  failureThreshold = 6;
                  httpGet = {
                    path = "/health/readiness";
                    port = 9443;
                    scheme = "HTTPS";
                  };
                  initialDelaySeconds = 5;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
                volumeMounts = [
                  {
                    mountPath = "/.sigstore";
                    name = "sigstore";
                  }
                ];
              }
            ];
            volumes = [
              {
                name = "sigstore";
                emptyDir = { };
              }
            ];
          };
        };
      };
    }
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "kyverno-background-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "background-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      spec = {
        replicas = null;
        revisionHistoryLimit = 10;
        strategy = {
          rollingUpdate = {
            maxSurge = 1;
            maxUnavailable = "40%";
          };
          type = "RollingUpdate";
        };
        selector = {
          matchLabels = {
            "app.kubernetes.io/component" = "background-controller";
            "app.kubernetes.io/instance" = "kyverno";
            "app.kubernetes.io/part-of" = "kyverno";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "background-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
              "app.kubernetes.io/version" = "v1.16.1";
            };
          };
          spec = {
            dnsPolicy = "ClusterFirst";
            affinity = {
              podAntiAffinity = {
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    podAffinityTerm = {
                      labelSelector = {
                        matchExpressions = [
                          {
                            key = "app.kubernetes.io/component";
                            operator = "In";
                            values = [ "background-controller" ];
                          }
                        ];
                      };
                      topologyKey = "kubernetes.io/hostname";
                    };
                    weight = 1;
                  }
                ];
              };
            };
            serviceAccountName = "kyverno-background-controller";
            automountServiceAccountToken = true;
            containers = [
              {
                name = "controller";
                image = "reg.kyverno.io/kyverno/background-controller:v1.16.1";
                imagePullPolicy = "IfNotPresent";
                ports = [
                  {
                    containerPort = 9443;
                    name = "https";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 8000;
                    name = "metrics";
                    protocol = "TCP";
                  }
                ];
                args = [
                  "--disableMetrics=false"
                  "--otelConfig=prometheus"
                  "--metricsPort=8000"
                  "--resyncPeriod=15m"
                  "--enableConfigMapCaching=true"
                  "--enableDeferredLoading=true"
                  "--maxAPICallResponseLength=2000000"
                  "--loggingFormat=text"
                  "--v=2"
                  "--omitEvents=PolicyApplied,PolicySkipped"
                  "--enablePolicyException=false"
                  "--enableReporting=validate,mutate,mutateExisting,imageVerify,generate"
                ];
                env = [
                  {
                    name = "KYVERNO_SERVICEACCOUNT_NAME";
                    value = "kyverno-background-controller";
                  }
                  {
                    name = "KYVERNO_DEPLOYMENT";
                    value = "kyverno-background-controller";
                  }
                  {
                    name = "INIT_CONFIG";
                    value = "kyverno";
                  }
                  {
                    name = "METRICS_CONFIG";
                    value = "kyverno-metrics";
                  }
                  {
                    name = "KYVERNO_POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                ];
                resources = {
                  limits = {
                    memory = "128Mi";
                  };
                  requests = {
                    cpu = "100m";
                    memory = "64Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  privileged = false;
                  readOnlyRootFilesystem = true;
                  runAsNonRoot = true;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
              }
            ];
          };
        };
      };
    }
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "kyverno-cleanup-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "cleanup-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      spec = {
        replicas = null;
        revisionHistoryLimit = 10;
        strategy = {
          rollingUpdate = {
            maxSurge = 1;
            maxUnavailable = "40%";
          };
          type = "RollingUpdate";
        };
        selector = {
          matchLabels = {
            "app.kubernetes.io/component" = "cleanup-controller";
            "app.kubernetes.io/instance" = "kyverno";
            "app.kubernetes.io/part-of" = "kyverno";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "cleanup-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
              "app.kubernetes.io/version" = "v1.16.1";
            };
          };
          spec = {
            dnsPolicy = "ClusterFirst";
            affinity = {
              podAntiAffinity = {
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    podAffinityTerm = {
                      labelSelector = {
                        matchExpressions = [
                          {
                            key = "app.kubernetes.io/component";
                            operator = "In";
                            values = [ "cleanup-controller" ];
                          }
                        ];
                      };
                      topologyKey = "kubernetes.io/hostname";
                    };
                    weight = 1;
                  }
                ];
              };
            };
            serviceAccountName = "kyverno-cleanup-controller";
            automountServiceAccountToken = true;
            containers = [
              {
                name = "controller";
                image = "reg.kyverno.io/kyverno/cleanup-controller:v1.16.1";
                imagePullPolicy = "IfNotPresent";
                ports = [
                  {
                    containerPort = 9443;
                    name = "https";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 8000;
                    name = "metrics";
                    protocol = "TCP";
                  }
                ];
                args = [
                  "--caSecretName=kyverno-cleanup-controller.kyverno.svc.kyverno-tls-ca"
                  "--tlsSecretName=kyverno-cleanup-controller.kyverno.svc.kyverno-tls-pair"
                  "--servicePort=443"
                  "--resyncPeriod=15m"
                  "--cleanupServerPort=9443"
                  "--disableMetrics=false"
                  "--otelConfig=prometheus"
                  "--metricsPort=8000"
                  "--enableDeferredLoading=true"
                  "--dumpPayload=false"
                  "--maxAPICallResponseLength=2000000"
                  "--loggingFormat=text"
                  "--v=2"
                  "--protectManagedResources=false"
                  "--ttlReconciliationInterval=1m"
                ];
                env = [
                  {
                    name = "KYVERNO_DEPLOYMENT";
                    value = "kyverno-cleanup-controller";
                  }
                  {
                    name = "INIT_CONFIG";
                    value = "kyverno";
                  }
                  {
                    name = "METRICS_CONFIG";
                    value = "kyverno-metrics";
                  }
                  {
                    name = "KYVERNO_POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_SERVICEACCOUNT_NAME";
                    value = "kyverno-cleanup-controller";
                  }
                  {
                    name = "KYVERNO_ROLE_NAME";
                    value = "kyverno:cleanup-controller";
                  }
                  {
                    name = "KYVERNO_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_SVC";
                    value = "kyverno-cleanup-controller";
                  }
                ];
                resources = {
                  limits = {
                    memory = "128Mi";
                  };
                  requests = {
                    cpu = "100m";
                    memory = "64Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  privileged = false;
                  readOnlyRootFilesystem = true;
                  runAsNonRoot = true;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
                startupProbe = {
                  failureThreshold = 20;
                  httpGet = {
                    path = "/health/liveness";
                    port = 9443;
                    scheme = "HTTPS";
                  };
                  initialDelaySeconds = 2;
                  periodSeconds = 6;
                };
                livenessProbe = {
                  failureThreshold = 2;
                  httpGet = {
                    path = "/health/liveness";
                    port = 9443;
                    scheme = "HTTPS";
                  };
                  initialDelaySeconds = 15;
                  periodSeconds = 30;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
                readinessProbe = {
                  failureThreshold = 6;
                  httpGet = {
                    path = "/health/readiness";
                    port = 9443;
                    scheme = "HTTPS";
                  };
                  initialDelaySeconds = 5;
                  periodSeconds = 10;
                  successThreshold = 1;
                  timeoutSeconds = 5;
                };
              }
            ];
          };
        };
      };
    }
    {
      apiVersion = "apps/v1";
      kind = "Deployment";
      metadata = {
        name = "kyverno-reports-controller";
        namespace = "kyverno";
        labels = {
          "app.kubernetes.io/component" = "reports-controller";
          "app.kubernetes.io/instance" = "kyverno";
          "app.kubernetes.io/part-of" = "kyverno";
          "app.kubernetes.io/version" = "v1.16.1";
        };
      };
      spec = {
        replicas = null;
        revisionHistoryLimit = 10;
        strategy = {
          rollingUpdate = {
            maxSurge = 1;
            maxUnavailable = "40%";
          };
          type = "RollingUpdate";
        };
        selector = {
          matchLabels = {
            "app.kubernetes.io/component" = "reports-controller";
            "app.kubernetes.io/instance" = "kyverno";
            "app.kubernetes.io/part-of" = "kyverno";
          };
        };
        template = {
          metadata = {
            labels = {
              "app.kubernetes.io/component" = "reports-controller";
              "app.kubernetes.io/instance" = "kyverno";
              "app.kubernetes.io/part-of" = "kyverno";
              "app.kubernetes.io/version" = "v1.16.1";
            };
          };
          spec = {
            dnsPolicy = "ClusterFirst";
            affinity = {
              podAntiAffinity = {
                preferredDuringSchedulingIgnoredDuringExecution = [
                  {
                    podAffinityTerm = {
                      labelSelector = {
                        matchExpressions = [
                          {
                            key = "app.kubernetes.io/component";
                            operator = "In";
                            values = [ "reports-controller" ];
                          }
                        ];
                      };
                      topologyKey = "kubernetes.io/hostname";
                    };
                    weight = 1;
                  }
                ];
              };
            };
            serviceAccountName = "kyverno-reports-controller";
            automountServiceAccountToken = true;
            containers = [
              {
                name = "controller";
                image = "reg.kyverno.io/kyverno/reports-controller:v1.16.1";
                imagePullPolicy = "IfNotPresent";
                ports = [
                  {
                    containerPort = 9443;
                    name = "https";
                    protocol = "TCP";
                  }
                  {
                    containerPort = 8000;
                    name = "metrics";
                    protocol = "TCP";
                  }
                ];
                args = [
                  "--disableMetrics=false"
                  "--openreportsEnabled=false"
                  "--otelConfig=prometheus"
                  "--metricsPort=8000"
                  "--resyncPeriod=15m"
                  "--admissionReports=true"
                  "--aggregateReports=true"
                  "--policyReports=true"
                  "--validatingAdmissionPolicyReports=true"
                  "--mutatingAdmissionPolicyReports=false"
                  "--backgroundScan=true"
                  "--backgroundScanWorkers=2"
                  "--backgroundScanInterval=1h"
                  "--skipResourceFilters=true"
                  "--enableConfigMapCaching=true"
                  "--enableDeferredLoading=true"
                  "--maxAPICallResponseLength=2000000"
                  "--loggingFormat=text"
                  "--v=2"
                  "--omitEvents=PolicyApplied,PolicySkipped"
                  "--enablePolicyException=false"
                  "--allowInsecureRegistry=false"
                  "--registryCredentialHelpers=default,google,amazon,azure,github"
                  "--enableReporting=validate,mutate,mutateExisting,imageVerify,generate"
                ];
                env = [
                  {
                    name = "KYVERNO_SERVICEACCOUNT_NAME";
                    value = "kyverno-reports-controller";
                  }
                  {
                    name = "KYVERNO_DEPLOYMENT";
                    value = "kyverno-reports-controller";
                  }
                  {
                    name = "INIT_CONFIG";
                    value = "kyverno";
                  }
                  {
                    name = "METRICS_CONFIG";
                    value = "kyverno-metrics";
                  }
                  {
                    name = "KYVERNO_POD_NAME";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.name";
                      };
                    };
                  }
                  {
                    name = "KYVERNO_NAMESPACE";
                    valueFrom = {
                      fieldRef = {
                        fieldPath = "metadata.namespace";
                      };
                    };
                  }
                  {
                    name = "TUF_ROOT";
                    value = "/.sigstore";
                  }
                ];
                resources = {
                  limits = {
                    memory = "128Mi";
                  };
                  requests = {
                    cpu = "100m";
                    memory = "64Mi";
                  };
                };
                securityContext = {
                  allowPrivilegeEscalation = false;
                  capabilities = {
                    drop = [ "ALL" ];
                  };
                  privileged = false;
                  readOnlyRootFilesystem = true;
                  runAsNonRoot = true;
                  seccompProfile = {
                    type = "RuntimeDefault";
                  };
                };
                volumeMounts = [
                  {
                    mountPath = "/.sigstore";
                    name = "sigstore";
                  }
                ];
              }
            ];
            volumes = [
              {
                name = "sigstore";
                emptyDir = { };
              }
            ];
          };
        };
      };
    }
  ];
}
