_: {
  services.k3s.manifests."cert-manager-service".content = [
    {
      apiVersion = "v1";
      kind = "Service";
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
        type = "ClusterIP";
        ports = [
          {
            protocol = "TCP";
            port = 9402;
            name = "tcp-prometheus-servicemonitor";
            targetPort = 9402;
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "cert-manager";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "controller";
        };
      };
    }
    {
      apiVersion = "v1";
      kind = "Service";
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
        type = "ClusterIP";
        ports = [
          {
            name = "https";
            port = 443;
            protocol = "TCP";
            targetPort = "https";
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "webhook";
          "app.kubernetes.io/instance" = "cert-manager";
          "app.kubernetes.io/component" = "webhook";
        };
      };
    }
  ];
}
