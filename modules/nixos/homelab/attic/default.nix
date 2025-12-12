{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [ ];

  options.homelab.attic = {
    enable = lib.mkEnableOption "attic";

    resources = lib.mkOption {
      type = types.attrsOf (types.attrsOf (types.nullOr types.str));
      description = "Resource requests/limits for attic container.";
    };
  };
}
