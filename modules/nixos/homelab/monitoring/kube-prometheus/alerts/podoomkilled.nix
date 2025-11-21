{ ... }:
{
  services.k3s.manifests.podoomkilled-alert.content = {
    apiVersion = "monitoring.coreos.com/v1";
    kind = "PrometheusRule";
    metadata = {
      name = "prometheus-pod-oom-killed";
      namespace = "monitoring";
    };
    spec = {
      groups = [
        {
          name = "kubernetes-pod-alerts";
          rules = [
            {
              alert = "PodOOMKilled";
              annotations = {
                description = "Container {{ $labels.container }} in pod {{ $labels.pod }} (namespace {{ $labels.namespace }}) has been terminated due to OOMKill in the last 5 minutes.";
                runbook_url = "https://qed.getoutline.com/doc/podoomkilled-8iFHoPUtSO";
                summary = "Pod {{ $labels.namespace }}/{{ $labels.pod }} terminated due to OOMKill";
              };
              expr = "kube_pod_labels * on (namespace, pod) group_right(label_alertmanager_i_qed_ai_project) (\n  sum_over_time(kube_pod_container_status_terminated_reason{reason=\"OOMKilled\"}[5m]) > 0\n)\n";
              labels = {
                category = "kubernetes";
                component = "pod";
                severity = "warning";
              };
            }
            {
              alert = "PodOOMKilledWithRestart";
              annotations = {
                description = "Container {{ $labels.container }} in pod {{ $labels.pod }} (namespace {{ $labels.namespace }}) has restarted{{ if ge $value 2.0 }} {{ printf \"%.0f\" $value }} times{{ end }} in the last 30 minutes due to OOMKill.";
                runbook_url = "https://qed.getoutline.com/doc/podoomkilledwithrestart-6SeMSOXqJ4";
                summary = "Pod {{ $labels.namespace }}/{{ $labels.pod }} restarted due to OOMKill";
              };
              expr = "kube_pod_labels * on (namespace, pod) group_right(label_alertmanager_i_qed_ai_project) (\n      increase(kube_pod_container_status_restarts_total[30m]) > 0\n    and on (namespace, pod, container)\n      kube_pod_container_status_last_terminated_reason{reason=\"OOMKilled\"}\n  # exclude specific instances that are not worth addressing\n  unless on (namespace, pod, container)\n    (\n        # data portals\n        kube_pod_container_status_restarts_total{container=\"object-file-browser\"}\n      or\n        # smokeping_prober slowly leaks memory and gets killed once every few days\n        # As of 2025-07-29 it's deployed only on gke-{test,prod}, but the plan is to\n        # ultimately migrate it to other clusters.\n        kube_pod_container_status_restarts_total{\n          container=\"smokeping-prober\",\n          pod=~\"smokeping-prober-.+\",\n        }\n    )\n)\n";
              labels = {
                category = "kubernetes";
                component = "pod";
                severity = "warning";
              };
            }
          ];
        }
      ];
    };
  };
}
