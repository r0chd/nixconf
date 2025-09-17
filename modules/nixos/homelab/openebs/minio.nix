{ ... }:
{
  services.k3s.manifests.minio-service.content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "minio";
      namespace = "openebs-system";
    };
    spec = {
      type = "ClusterIP";
      selector.app = "openebs-minio";
      ports = [
        {
          port = 9000;
          targetPort = 9000;
          protocol = "TCP";
          name = "http";
        }
      ];
    };
  };
}
