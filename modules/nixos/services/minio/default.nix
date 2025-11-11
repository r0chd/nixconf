{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.services.minio.buckets = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
      }
    );
  };
}
