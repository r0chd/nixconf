_: {
  config.services.k3s.autoDeployCharts.cert-manager.extraDeploy = [
    {
      apiVersion = "cert-manager.io/v1";
      kind = "ClusterIssuer";
      metadata = {
        name = "letsencrypt";
        namespace = "cert-manager";
      };
      spec.acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory";
        email = "oskarrochowiak@gmail.com";
        privateKeySecretRef.name = "letsencrypt";
        solvers = [ { http01.ingress.class = "ingress-nginx"; } ];
      };
    }
    {
      apiVersion = "cert-manager.io/v1";
      kind = "Certificate";
      metadata = {
        name = "ssl-cert";
        namespace = "cert-manager";
      };
      spec = {
        secretName = "ssl-cert";
        issuerRef = {
          name = "selfsigned-issuer";
          kind = "ClusterIssuer";
        };
        commonName = "*.your-domain.com";
        dnsNames = [
          "*.your-domain.com"
          "your-domain.com"
        ];
      };
    }
  ];
}
