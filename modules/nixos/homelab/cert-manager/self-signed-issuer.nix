_: {
  services.k3s.manifests."cert-manager-self-signed-issuer".content = [
    {
      apiVersion = "cert-manager.io/v1";
      kind = "ClusterIssuer";
      metadata.name = "self-signed-issuer";
      spec.selfSigned = { };
    }
  ];
}
