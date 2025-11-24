_:
{
  services.k3s.manifests.quickwit-ingest-stalled-alert.content = {
    apiVersion = "monitoring.coreos.com/v1";
    kind = "PrometheusRule";
    metadata = {
      name = "quickwit-ingest-stalled";
      namespace = "monitoring";
    };
    spec = {
      groups = [
        {
          name = "quickwit";
          rules = [
            {
              alert = "QuickwitIngestStalled";
              expr = "changes(quickwit_ingest_ingested_num_docs[2h]) == 0";
              for = "10m";
              labels = {
                severity = "error";
              };
              annotations = {
                summary = "Quickwit ingest activity has stalled for 2h";
                description = "The metric `quickwit_ingest_ingested_num_docs` has not changed in the past 2 hours, Quickwit may have stopped ingesting new documents.";
              };
            }
          ];
        }
      ];
    };
  };
}
