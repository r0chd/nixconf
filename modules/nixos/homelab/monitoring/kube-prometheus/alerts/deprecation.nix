_:
{
  services.k3s.manifests.deprecation-alert.content = {
    apiVersion = "monitoring.coreos.com/v1";
    kind = "PrometheusRule";
    metadata = {
      name = "prometheus-kubernetes-deprecations";
      namespace = "monitoring";
    };
    spec = {
      groups = [
        {
          name = "kubernetes-deprecations";
          rules = [
            {
              alert = "DeprecatedApiInUse";
              expr = "group by(group, version, resource) (\n  apiserver_requested_deprecated_apis{removed_release=\"1.28\"}\n)\n  and\n(sum by(group, version, resource) (rate(apiserver_request_total[10m]))) > 0\n";
              labels = {
                severity = "warning";
              };
              annotations = {
                summary = "Deprecated Kubernetes API is being used.";
                description = "Deprecated API ({{ $labels.group }}/{{ $labels.version }}/{{ $labels.resource }}) that will be removed in the next version is being used. Removing the workload that is using the API might be necessary for a successful upgrade to the next cluster version. Refer to the audit logs to identify the workload.";
              };
            }
          ];
        }
      ];
    };
  };
}
