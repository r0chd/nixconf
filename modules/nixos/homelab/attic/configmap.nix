{ config, lib, ... }:
let
  cfg = config.homelab.attic;
in
{
  config = lib.mkIf cfg.enable {
    services.k3s.manifests.attic-configmap.content = [
      {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "attic-config";
          namespace = "attic";
          labels = {
            "app.kubernetes.io/name" = "attic-server";
          };
        };
        data."config.toml" =
          # toml
          ''
            listen = "[::]:8080"

            # Data chunking
            #
            # Warning: If you change any of the values here, it will be
            # difficult to reuse existing chunks for newly-uploaded NARs
            # since the chunking boundary will be different. As a result,
            # the deduplication ratio will suffer for a while after the
            # change.
            [chunking]
            # The minimum NAR size to trigger chunking
            #
            # If 0, chunking is disabled entirely for newly-uploaded NARs.
            # If 1, all NARs are chunked.
            nar-size-threshold = 65536 # 64 KiB

            # The preferred minimum size of a chunk, in bytes
            min-size = 16384 # 16 KiB

            # The preferred average size of a chunk, in bytes
            avg-size = 65536 # 64 KiB

            # The preferred maximum size of a chunk, in bytes
            max-size = 262144 # 256 KiB

            # Compression
            [compression]
            type = "zstd"

            # Database
            [database]
            url = "sqlite:///srv/store/attic.db?mode=rwc"

            # Storage
            [storage]
            type = "local"
            path = "/srv/store"

            # Garbage collection
            [garbage-collection]
            # The frequency to run garbage collection at.
            #
            # If zero, automatic garbage collection is disabled, but
            # can be manually triggered via the CLI
            interval = "12 hours"

            # Default retention period
            #
            # Zero means time-based garbage collection is disabled by default.
            # Objects can still be garbage collected if the maximum size is reached.
            default-retention-period = "3 months"
          '';
      }
    ];
  };
}
