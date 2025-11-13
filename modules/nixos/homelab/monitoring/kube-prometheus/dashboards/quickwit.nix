{ lib, ... }:
{
  services.k3s.manifests.grafana-quickwit-dashboard.content = [
    {
      apiVersion = "v1";
      kind = "ConfigMap";
      metadata = {
        name = "quickwit-dashboard";
        namespace = "monitoring";
        labels = {
          grafana_dashboard = "1";
        };
      };
      data."quickwit.json" = lib.generators.toJSON { } {
        annotations = {
          list = [
            {
              builtIn = 1;
              datasource = {
                type = "datasource";
                uid = "grafana";
              };
              enable = true;
              hide = true;
              iconColor = "rgba(0, 211, 255, 1)";
              name = "Annotations & Alerts";
              type = "dashboard";
            }
          ];
        };
        editable = true;
        fiscalYearStartMonth = 0;
        graphTooltip = 0;
        id = 2;
        links = [ ];
        panels = [
          {
            datasource = {
              type = "quickwit-quickwit-datasource";
              uid = "quickwit";
            };
            fieldConfig = {
              defaults = {
                color = {
                  mode = "palette-classic";
                };
                custom = {
                  axisBorderShow = false;
                  axisCenteredZero = false;
                  axisColorMode = "text";
                  axisLabel = "Log Count";
                  axisPlacement = "auto";
                  barAlignment = 0;
                  barWidthFactor = 0.6;
                  drawStyle = "bars";
                  fillOpacity = 80;
                  gradientMode = "none";
                  hideFrom = {
                    tooltip = false;
                    viz = false;
                    legend = false;
                  };
                  insertNulls = false;
                  lineInterpolation = "linear";
                  lineWidth = 1;
                  pointSize = 5;
                  scaleDistribution = {
                    type = "linear";
                  };
                  showPoints = "never";
                  spanNulls = false;
                  stacking = {
                    group = "A";
                    mode = "none";
                  };
                  thresholdsStyle = {
                    mode = "off";
                  };
                };
                mappings = [ ];
                thresholds = {
                  mode = "absolute";
                  steps = [
                    {
                      color = "green";
                      value = null;
                    }
                  ];
                };
                unit = "short";
              };
              overrides = [ ];
            };
            gridPos = {
              h = 8;
              w = 24;
              x = 0;
              y = 0;
            };
            id = 7;
            options = {
              legend = {
                calcs = [
                  "sum"
                  "mean"
                  "max"
                ];
                displayMode = "table";
                placement = "bottom";
                showLegend = true;
              };
              tooltip = {
                mode = "multi";
                sort = "none";
              };
            };
            pluginVersion = "12.1.1";
            targets = [
              {
                bucketAggs = [
                  {
                    field = "timestamp_nanos";
                    id = "2";
                    settings = {
                      interval = "auto";
                      min_doc_count = "0";
                      trimEdges = "0";
                    };
                    type = "date_histogram";
                  }
                ];
                datasource = {
                  type = "quickwit-quickwit-datasource";
                  uid = "quickwit";
                };
                index = "logs";
                metrics = [
                  {
                    id = "1";
                    type = "count";
                  }
                ];
                query = "\${log_query: raw}";
                refId = "A";
              }
            ];
            title = "Logs Volume Over Time";
            type = "timeseries";
          }
          {
            datasource = {
              type = "quickwit-quickwit-datasource";
              uid = "quickwit";
            };
            fieldConfig = {
              defaults = { };
              overrides = [ ];
            };
            gridPos = {
              h = 18;
              w = 24;
              x = 0;
              y = 8;
            };
            id = 6;
            options = {
              dedupStrategy = "none";
              enableInfiniteScrolling = false;
              enableLogDetails = true;
              prettifyLogMessage = false;
              showCommonLabels = false;
              showLabels = false;
              showTime = true;
              sortOrder = "Descending";
              wrapLogMessage = true;
            };
            pluginVersion = "12.1.1";
            targets = [
              {
                bucketAggs = [ ];
                datasource = {
                  type = "quickwit-quickwit-datasource";
                  uid = "quickwit";
                };
                index = "logs";
                metrics = [
                  {
                    id = "1";
                    settings = {
                      limit = "$log_limit";
                    };
                    type = "logs";
                  }
                ];
                query = "\${log_query: raw}";
                refId = "A";
              }
            ];
            title = "Recent Quickwit Logs";
            type = "logs";
          }
        ];
        preload = false;
        refresh = "1m";
        schemaVersion = 41;
        tags = [
          "quickwit"
          "logs"
        ];
        templating = {
          list = [
            {
              baseFilters = [ ];
              datasource = {
                type = "quickwit-quickwit-datasource";
                uid = "quickwit";
              };
              filters = [ ];
              name = "Filters";
              type = "adhoc";
            }
            {
              current = {
                text = "100";
                value = "100";
              };
              label = "Log Limit";
              name = "log_limit";
              options = [
                {
                  selected = false;
                  text = "10";
                  value = "10";
                }
                {
                  selected = false;
                  text = "50";
                  value = "50";
                }
                {
                  selected = true;
                  text = "100";
                  value = "100";
                }
                {
                  selected = false;
                  text = "500";
                  value = "500";
                }
                {
                  selected = false;
                  text = "1000";
                  value = "1000";
                }
              ];
              query = "10,50,100,500,1000";
              type = "custom";
            }
            {
              current = {
                text = "*";
                value = "*";
              };
              label = "Enter value";
              name = "log_query";
              options = [
                {
                  selected = true;
                  text = "*";
                  value = "*";
                }
              ];
              query = "*";
              type = "textbox";
            }
          ];
        };
        time = {
          from = "now-30m";
          to = "now";
        };
        timepicker = { };
        timezone = "browser";
        title = "Quickwit Overview";
        uid = "ccc52d36-5a7f-4b73-b1ce-5cb2e83dc499";
        version = 8;
      };
    }
  ];
}
