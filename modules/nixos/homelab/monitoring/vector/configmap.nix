{ lib, config, ... }:
{
  config = lib.mkIf (config.homelab.enable && config.homelab.monitoring.vector.enable) {
    services.k3s.manifests."vector-configmap".content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "vector";
          namespace = "monitoring";
          labels = {
            "app.kubernetes.io/name" = "vector";
            "app.kubernetes.io/instance" = "vector";
            "app.kubernetes.io/component" = "Agent";
            "app.kubernetes.io/version" = "0.51.0-distroless-libc";
          };
        };
        data = {
          "agent.yaml" =
            # yaml
            ''
              data_dir: "/vector-data-dir"
              api:
                enabled: false
              sources:
                kubernetes_logs:
                  type: "kubernetes_logs"
                  self_node_name: "''${VECTOR_SELF_NODE_NAME}"
              transforms:
                remap_k8s_logs:
                  inputs:
                    - "kubernetes_logs"
                  type: "remap"
                  source: |
                    service_name = .kubernetes.pod_labels."app.kubernetes.io/name"
                    if is_null(service_name) {
                      service_name = .kubernetes.container_name
                    }
                    .service_name = to_string(service_name) ?? "unkown"

                    .timestamp_nanos = to_unix_timestamp!(.timestamp, unit: "nanoseconds")
                    .resource_attributes = {
                      "source_type": .source_type,
                      "host": {
                        "hostname": .kubernetes.pod_node_name
                      },
                      "service": {
                        "name": .service_name
                      },
                      "k8s": {
                        "namespace_name": .kubernetes.pod_namespace,
                        "pod_name": .kubernetes.pod_name,
                        "container_name": .kubernetes.container_name
                      }
                    }
                    .attributes = {
                      "container_id": .kubernetes.container_id,
                      "container_image": .kubernetes.container_image,
                      "stream": .stream
                    }
                    .scope_name = .kubernetes.container_name

                    .severity_text = "INFO"

                    if .service_name == "ingress-nginx" {
                      parsed, err = parse_nginx_log(.message, "combined")
                      if err == null && exists(parsed.status) {
                        status_code = to_int(parsed.status)
                        if status_code >= 500 {
                          .severity_text = "ERROR"
                        } else if status_code >= 400 {
                          .severity_text = "WARN"
                        }
                      }
                      .body.message = parsed
                    } else if starts_with(.service_name, "thanos-") ||
                        service_name == "grafana" ||
                        service_name == "httpbingo" ||
                        service_name == "external-dns" {
                      parsed, err = parse_logfmt(.message)
                      if err == null {
                        .body.message = parsed
                        severity_text, err = upcase(.body.message.level)
                        if err == null {
                          .severity_text = severity_text
                        }
                      }
                    } else if .service_name == "postgres" {
                      parsed, err = parse_json(.message)
                      if err == null {
                        .body.message = parsed
                        severity_text, err = upcase(.body.message.level)
                        if err == null {
                          .severity_text = severity_text
                        }
                      }
                    }

                    .body.message.text = join!([.kubernetes.pod_name, .message], separator: " | ")

                    del(.kubernetes)
                    del(.file)
                    del(.message)
                    del(.source_type)
                    del(.stream)
                    del(.timestamp)
              sinks:
                emit_logs:
                  inputs:
                    - "remap_k8s_logs"
                  type: "console"
                  encoding:
                    codec: "json"
                quickwit_logs:
                  type: "http"
                  method: "post"
                  inputs:
                    - "remap_k8s_logs"
                  encoding:
                    codec: "json"
                  framing:
                    method: "newline_delimited"
                  uri: "http://quickwit-indexer.monitoring.svc.cluster.local:7280/api/v1/logs/ingest"
            '';
        };
      }
    ];
  };
}
