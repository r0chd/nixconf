_: {
  services.k3s.manifests.atuin.content = [
    {
      apiVersion = "networking.k8s.io/v1";
      kind = "Ingress";
      metadata = {
        name = "atuin-ingress";
        namespace = "atuin";
      };
      spec = {
        ingressClassName = "ingress-nginx";
        rules = [
          {

            host = "atuin.example.com";
            http = {
              paths = [
                {
                  path = "/";
                  pathType = "Prefix";
                  backend = {
                    service = {
                      name = "atuin";
                      port.number = 8888;
                    };
                  };
                }
              ];
            };
          }
        ];
      };
    }
  ];
}
