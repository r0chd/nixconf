{ ... }:
{
  services.k3s.manifests.ingress-nginx-service.content = [
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/version" = "1.14.0";
          "app.kubernetes.io/part-of" = "ingress-nginx";
          "app.kubernetes.io/component" = "controller";
        };
        name = "ingress-nginx-controller-admission";
        namespace = "ingress-nginx";
      };
      spec = {
        type = "ClusterIP";
        ports = [
          {
            name = "https-webhook";
            port = 443;
            targetPort = "webhook";
            appProtocol = "https";
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/component" = "controller";
        };
      };
    }
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        annotations = null;
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
        type = "LoadBalancer";
        ipFamilyPolicy = "SingleStack";
        ipFamilies = [ "IPv4" ];
        ports = [
          {
            name = "http";
            port = 80;
            protocol = "TCP";
            targetPort = "http";
            appProtocol = "http";
          }
          {
            name = "https";
            port = 443;
            protocol = "TCP";
            targetPort = "https";
            appProtocol = "https";
          }
        ];
        selector = {
          "app.kubernetes.io/name" = "ingress-nginx";
          "app.kubernetes.io/instance" = "ingress-nginx";
          "app.kubernetes.io/component" = "controller";
        };
      };
    }
  ];
}
