_: {
  services.k3s.manifests.atuin.content = [
    {
      apiVersion = "v1";
      kind = "Service";
      metadata = {
        labels."io.kompose.service" = "postgres";
        name = "postgres";
        namespace = "atuin";
      };
      spec = {
        type = "ClusterIP";
        selector = {
          "app.kubernetes.io/managed-by" = "Kustomize";
          "io.kompose.service" = "postgres";
        };
        ports = [
          {
            protocol = "TCP";
            port = 5432;
            targetPort = 5432;
          }
        ];
      };
    }
  ];
}
