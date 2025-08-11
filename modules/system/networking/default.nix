{ lib, config, ... }:
let
  cfg = config.networking;
  inherit (lib) types;
in
{
  options.networking.hostName = lib.mkOption {
    type = types.nullOr types.str;
    default = null;
  };

  config.environment.etc."hostname" = lib.mkIf (cfg.hostName != null) {
    text = cfg.hostName;
  };
}
