{ ... }:
{
  config.services.k3s.autoDeployCharts.cert-manager.extraDeploy = [
    {
      apiVersion = "cert-manager.io/v1";
      kind = "ClusterIssuer";
      metadata = {
        name = "selfsigned-issuer";
      };
      spec.selfSigned = { };
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
