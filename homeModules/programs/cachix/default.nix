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
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    #home.file.".config/cachix/cachix.dhall".text = ''
    #  { authToken = ${cfg.authToken}
    #  , hostname = "https://cachix.org"
    #  , binaryCaches = [] : List { name : Text, secretKey : Text }
    #  }
    #'';
  };
}
