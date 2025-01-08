{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.cachix;
in
{
  options.programs.cachix = {
    enable = lib.mkEnableOption "Cachix";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.cachix;
      description = "The Cachix package to use";
    };
    authToken = lib.mkOption {
      type = lib.types.str;
    };
    authTokenFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
