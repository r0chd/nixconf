{ config, lib, ... }:
let
  cfg = config.homelab.monitoring.kube-resource-report;
in
{
  config = lib.mkIf (config.homelab.enable && cfg.enable) {
    services.k3s.manifests.kube-resource-report-rbac.content = [
      {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "kube-resource-report";
          namespace = "monitoring";
        };
      }
      {
        kind = "ClusterRole";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "kube-resource-report";
          namespace = "monitoring";
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [
              "nodes"
              "pods"
              "namespaces"
              "services"
            ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "networking.k8s.io" ];
            resources = [ "ingresses" ];
            verbs = [ "list" ];
          }
          {
            apiGroups = [ "metrics.k8s.io" ];
            resources = [
              "nodes"
              "pods"
            ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "services/proxy" ];
            resourceNames = [ "heapster" ];
            verbs = [ "get" ];
          }
          {
            apiGroups = [ "autoscaling.k8s.io" ];
            resources = [ "verticalpodautoscalers" ];
            verbs = [
              "get"
              "list"
            ];
          }
          {
            apiGroups = [ "apps" ];
            resources = [
              "deployments"
              "statefulsets"
              "replicasets"
              "daemonsets"
            ];
            verbs = [
              "get"
              "list"
            ];
          }
        ];
      }
      {
        kind = "ClusterRoleBinding";
        apiVersion = "rbac.authorization.k8s.io/v1";
        metadata = {
          name = "kube-resource-report";
          namespace = "monitoring";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "kube-resource-report";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "kube-resource-report";
            namespace = "monitoring";
          }
        ];
      }
    ];
  };
}
