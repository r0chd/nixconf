{ lib, config, ... }:
let
  cfg = config.nix;
  inherit (lib) types;
in
{
  options.nix.access-token-file = lib.mkOption {
    type = types.nullOr types.str;
    default = null;
  };

  config.nix.extraOptions = lib.mkIf (cfg.access-token-file != null) ''
    !include ${cfg.access-token-file}
  '';
}
