[
  {
    apiVersion = "v1";
    kind = "Namespace";
    metadata = {
      name = "dex";
    };
  }
  {
    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      labels = {
        app = "dex";
      };
      name = "dex";
      namespace = "dex";
    };
    spec = {
      replicas = 3;
      selector = {
        matchLabels = {
          app = "dex";
        };
      };
      template = {
        metadata = {
          labels = {
            app = "dex";
          };
        };
        spec = {
          serviceAccountName = "dex";
          containers = [
            {
              image = "ghcr.io/dexidp/dex:v2.32.0";
              name = "dex";
              command = [
                "/usr/local/bin/dex"
                "serve"
                "/etc/dex/cfg/config.yaml"
              ];
              ports = [
                {
                  name = "https";
                  containerPort = 5556;
                }
              ];
              volumeMounts = [
                {
                  name = "config";
                  mountPath = "/etc/dex/cfg";
                }
                {
                  name = "tls";
                  mountPath = "/etc/dex/tls";
                }
              ];
              env = [
                {
                  name = "GITHUB_CLIENT_ID";
                  valueFrom = {
                    secretKeyRef = {
                      name = "github-client";
                      key = "client-id";
                    };
                  };
                }
                {
                  name = "GITHUB_CLIENT_SECRET";
                  valueFrom = {
                    secretKeyRef = {
                      name = "github-client";
                      key = "client-secret";
                    };
                  };
                }
              ];
              readinessProbe = {
                httpGet = {
                  path = "/healthz";
                  port = 5556;
                  scheme = "HTTPS";
                };
              };
            }
          ];
          volumes = [
            {
              name = "config";
              configMap = {
                name = "dex";
                items = [
                  {
                    key = "config.yaml";
                    path = "config.yaml";
                  }
                ];
              };
            }
            {
              name = "tls";
              secret = {
                secretName = "dex.example.com.tls";
              };
            }
          ];
        };
      };
    };
  }
  {
    kind = "ConfigMap";
    apiVersion = "v1";
    metadata = {
      name = "dex";
      namespace = "dex";
    };
    data = {
      "config.yaml" =
        "issuer: https://dex.example.com:32000\nstorage:\n  type: kubernetes\n  config:\n    inCluster: true\nweb:\n  https: 0.0.0.0:5556\n  tlsCert: /etc/dex/tls/tls.crt\n  tlsKey: /etc/dex/tls/tls.key\nconnectors:\n- type: github\n  id: github\n  name: GitHub\n  config:\n    clientID: $GITHUB_CLIENT_ID\n    clientSecret: $GITHUB_CLIENT_SECRET\n    redirectURI: https://dex.example.com:32000/callback\n    org: kubernetes\noauth2:\n  skipApprovalScreen: true\n\nstaticClients:\n- id: example-app\n  redirectURIs:\n  - 'http://127.0.0.1:5555/callback'\n  name: 'Example App'\n  secret: ZXhhbXBsZS1hcHAtc2VjcmV0\n\nenablePasswordDB: true\nstaticPasswords:\n- email: \"admin@example.com\"\n  # bcrypt hash of the string \"password\": $(echo password | htpasswd -BinC 10 admin | cut -d: -f2)\n  hash: \"$2a$10$2b2cU8CPhOTaGrs1HRQuAueS7JTT5ZHsHSzYiFPm1leZck7Mc8T4W\"\n  username: \"admin\"\n  userID: \"08a8684b-db88-4b73-90a9-3cd1661f5466\"";
    };
  }
  {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "dex";
      namespace = "dex";
    };
    spec = {
      type = "NodePort";
      ports = [
        {
          name = "dex";
          port = 5556;
          protocol = "TCP";
          targetPort = 5556;
          nodePort = 32000;
        }
      ];
      selector = {
        app = "dex";
      };
    };
  }
  {
    apiVersion = "v1";
    kind = "ServiceAccount";
    metadata = {
      labels = {
        app = "dex";
      };
      name = "dex";
      namespace = "dex";
    };
  }
  {
    apiVersion = "rbac.authorization.k8s.io/v1";
    kind = "ClusterRole";
    metadata = {
      name = "dex";
    };
    rules = [
      {
        apiGroups = [ "dex.coreos.com" ];
        resources = [ "*" ];
        verbs = [ "*" ];
      }
      {
        apiGroups = [ "apiextensions.k8s.io" ];
        resources = [ "customresourcedefinitions" ];
        verbs = [ "create" ];
      }
    ];
  }
  {
    apiVersion = "rbac.authorization.k8s.io/v1";
    kind = "ClusterRoleBinding";
    metadata = {
      name = "dex";
    };
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io";
      kind = "ClusterRole";
      name = "dex";
    };
    subjects = [
      {
        kind = "ServiceAccount";
        name = "dex";
        namespace = "dex";
      }
    ];
  }
]
