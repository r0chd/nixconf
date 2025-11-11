{ ... }:
{
  services.k3s.manifests."metallb-L2Advertisement".content = [
    {
      apiVersion = "metallb.io/v1beta1";
      kind = "L2Advertisement";
      metadata = {
        name = "k3s-nuc-l2advertisment";
        namespace = "default";
      };
      spec = {
        ipAddressPools = [ "k3s-nuc-pool" ];
      };
    }
  ];
}
