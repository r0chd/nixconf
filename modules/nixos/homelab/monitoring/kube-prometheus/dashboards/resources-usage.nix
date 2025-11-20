{ lib, ... }:
{
  services.k3s.manifests.grafana-resources-usage-dashboard.content = [
    {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata = {
        name = "resources-usage-dashboard";
        namespace = "monitoring";
        labels = {
          grafana_dashboard = "1";
        };
      };
      data."resources-usage.json" = lib.generators.toJSON { } {
        annotations = {
          list = [
            {
              builtIn = 1;
              datasource = {
                type = "grafana";
                uid = "-- Grafana --";
              };
              enable = true;
              hide = true;
              iconColor = "rgba(0, 211, 255, 1)";
              name = "Annotations & Alerts";
              type = "dashboard";
            }
          ];
        };
        description = "Shows the differences between resource usage, requests and limits.";
        editable = true;
        fiscalYearStartMonth = 0;
        graphTooltip = 0;
        id = 52;
        links = [ ];
        panels = [
          {
            collapsed = false;
            gridPos = {
              h = 1;
              w = 24;
              x = 0;
              y = 0;
            };
            id = 4;
            panels = [ ];
            title = "Memory";
            type = "row";
          }
          {
            datasource = {
              name = "thanos";
              type = "prometheus";
            };
            fieldConfig = {
              defaults = {
                color = {
                  mode = "thresholds";
                };
                custom = {
                  align = "auto";
                  cellOptions = {
                    type = "auto";
                  };
                  inspect = false;
                };
                mappings = [ ];
                thresholds = {
                  mode = "absolute";
                  steps = [
                    {
                      color = "green";
                      value = 0;
                    }
                    {
                      color = "red";
                      value = 80;
                    }
                  ];
                };
                unit = "decbytes";
              };
              overrides = [
                {
                  matcher = {
                    id = "byName";
                    options = "Time";
                  };
                  properties = [
                    {
                      id = "custom.hidden";
                      value = true;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "k8s_cluster";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "cluster";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #lim";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "limit";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #req";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "requested";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #max(rss)";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "max(rss)";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #req - max(rss)";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "requested - max(rss)";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "workload";
                  };
                  properties = [
                    {
                      id = "links";
                      value = [
                        {
                          targetBlank = true;
                          title = "Drill down";
                          url = "https://grafana.de-test.i.qed.ai/d/a164a7f0339f99e89cea5cb47e9be617/kubernetes-compute-resources-workload?&var-datasource=default&var-cluster=\${__data.fields.k8s_cluster}&var-namespace=\${__data.fields.namespace}&var-type=\${__data.fields.workload_type}&var-workload=\${__data.fields.workload}&from=now-24h&to=now";
                        }
                      ];
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "cluster";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 73;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "namespace";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 168;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "limit";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 97;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "requested";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 96;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "max(rss)";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 94;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "workload_type";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 124;
                    }
                  ];
                }
              ];
            };
            gridPos = {
              h = 15;
              w = 24;
              x = 0;
              y = 1;
            };
            id = 2;
            options = {
              cellHeight = "sm";
              footer = {
                countRows = false;
                fields = "";
                reducer = [ "sum" ];
                show = false;
              };
              frameIndex = 191;
              showHeader = true;
              sortBy = [
                {
                  desc = true;
                  displayName = "requested - max(rss)";
                }
              ];
            };
            pluginVersion = "12.1.1";
            targets = [
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "max_over_time(\n  (max(\n    kube_pod_container_resource_limits{resource=\"memory\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "lim";
              }
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "max_over_time(\n  (max(\n    kube_pod_container_resource_requests{resource=\"memory\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "req";
              }
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "max_over_time(\n  (max(\n    container_memory_rss{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", container != \"\", container != \"POD\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "max(rss)";
              }
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "max_over_time(\n  (max(\n    kube_pod_container_resource_requests{resource=\"memory\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)\n-\nmax_over_time(\n  (max(\n    container_memory_rss{job=\"kubelet\", metrics_path=\"/metrics/cadvisor\", container != \"\", container != \"POD\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)\n";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "req - max(rss)";
              }
            ];
            title = "";
            transformations = [
              {
                id = "merge";
                options = { };
              }
              {
                id = "organize";
                options = {
                  excludeByName = { };
                  includeByName = { };
                  indexByName = {
                    Time = 0;
                    "Value #lim" = 6;
                    "Value #max(rss)" = 8;
                    "Value #req" = 7;
                    "Value #req - max(rss)" = 9;
                    container = 5;
                    k8s_cluster = 1;
                    namespace = 2;
                    workload = 4;
                    workload_type = 3;
                  };
                  renameByName = { };
                };
              }
            ];
            type = "table";
          }
          {
            collapsed = false;
            gridPos = {
              h = 1;
              w = 24;
              x = 0;
              y = 16;
            };
            id = 5;
            panels = [ ];
            title = "CPU";
            type = "row";
          }
          {
            datasource = {
              name = "thanos";
              type = "prometheus";
            };
            fieldConfig = {
              defaults = {
                color = {
                  mode = "thresholds";
                };
                custom = {
                  align = "auto";
                  cellOptions = {
                    type = "auto";
                  };
                  inspect = false;
                };
                mappings = [ ];
                thresholds = {
                  mode = "absolute";
                  steps = [
                    {
                      color = "green";
                      value = 0;
                    }
                    {
                      color = "red";
                      value = 80;
                    }
                  ];
                };
                unit = "sishort";
              };
              overrides = [
                {
                  matcher = {
                    id = "byName";
                    options = "Time";
                  };
                  properties = [
                    {
                      id = "custom.hidden";
                      value = true;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "k8s_cluster";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "cluster";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #lim";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "limit";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #req";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "requested";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #p95(cpu)";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "p95(cpu)";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "Value #req - p95(cpu)";
                  };
                  properties = [
                    {
                      id = "displayName";
                      value = "requested - p95(cpu)";
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "workload";
                  };
                  properties = [
                    {
                      id = "links";
                      value = [
                        {
                          targetBlank = true;
                          title = "Drill down";
                          url = "https://grafana.de-test.i.qed.ai/d/a164a7f0339f99e89cea5cb47e9be617/kubernetes-compute-resources-workload?&var-datasource=default&var-cluster=\${__data.fields.k8s_cluster}&var-namespace=\${__data.fields.namespace}&var-type=\${__data.fields.workload_type}&var-workload=\${__data.fields.workload}&from=now-24h&to=now";
                        }
                      ];
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "cluster";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 68;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "namespace";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 171;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "workload_type";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 115;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "requested";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 89;
                    }
                  ];
                }
                {
                  matcher = {
                    id = "byName";
                    options = "p95(cpu)";
                  };
                  properties = [
                    {
                      id = "custom.width";
                      value = 87;
                    }
                  ];
                }
              ];
            };
            gridPos = {
              h = 15;
              w = 24;
              x = 0;
              y = 17;
            };
            id = 3;
            options = {
              cellHeight = "sm";
              footer = {
                countRows = false;
                fields = "";
                reducer = [ "sum" ];
                show = false;
              };
              frameIndex = 191;
              showHeader = true;
              sortBy = [
                {
                  desc = true;
                  displayName = "requested - p95(cpu)";
                }
              ];
            };
            pluginVersion = "12.1.1";
            targets = [
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "max_over_time(\n  (max(\n    kube_pod_container_resource_requests{resource=\"cpu\", container!=\"\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "req";
              }
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "quantile_over_time(0.95,\n  (max(\n    node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{container != \"\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "p95(cpu)";
              }
              {
                datasource = {
                  name = "thanos";
                  type = "prometheus";
                };
                editorMode = "code";
                exemplar = false;
                expr = "max_over_time(\n  (max(\n    kube_pod_container_resource_requests{resource=\"cpu\", container!=\"\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)\n-\nquantile_over_time(0.95,\n  (max(\n    node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate{container!=\"\"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel\n  ) by (k8s_cluster, namespace, workload, workload_type, container))[$__range:]\n)\n";
                format = "table";
                hide = false;
                instant = true;
                legendFormat = "__auto";
                range = false;
                refId = "req - p95(cpu)";
              }
            ];
            title = "";
            transformations = [
              {
                id = "merge";
                options = { };
              }
              {
                id = "organize";
                options = {
                  excludeByName = { };
                  includeByName = { };
                  indexByName = {
                    Time = 0;
                    "Value #p95(cpu)" = 7;
                    "Value #req" = 6;
                    "Value #req - p95(cpu)" = 8;
                    container = 5;
                    k8s_cluster = 1;
                    namespace = 2;
                    workload = 4;
                    workload_type = 3;
                  };
                  renameByName = { };
                };
              }
            ];
            type = "table";
          }
        ];
        preload = false;
        schemaVersion = 41;
        tags = [ ];
        templating = {
          list = [ ];
        };
        time = {
          from = "now-7d";
          to = "now";
        };
        timepicker = { };
        timezone = "browser";
        title = "Resource Usage";
        uid = "86427c48-ac4c-41b2-8bee-6b9b46e8e6e8";
        version = 1;
      };
    }
  ];
}
