{ ... }:
{
  services.k3s.manifests."vault-disruptionbudget".content = [
    {
      apiVersion = "policy/v1beta1";
      kind = "PodDisruptionBudget";
      metadata = {
        name = "vault";
        namespace = "vault";
        labels = {
          "app.kubernetes.io/name" = "vault";
          "app.kubernetes.io/instance" = "vault";
        };
      };
      spec = {
        maxUnavailable = 0;
        selector.matchLabels = {
          "app.kubernetes.io/name" = "vault";
          "app.kubernetes.io/instance" = "vault";
          component = "server";
        };
      };
    }
  ];
}
