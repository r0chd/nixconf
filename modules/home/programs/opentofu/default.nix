{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.opentofu;
  inherit (lib) types;
in
{
  options.programs.opentofu = {
    enable = lib.mkEnableOption "opentofu";
    package = lib.mkPackageOption pkgs "opentofu" { };

    settings = {
      credentials = lib.mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              token = lib.mkOption {
                type = types.str;
                description = "secret token";
              };
            };
          }
        );
        default = { };
        description = "Credentials";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    sops.templates."opentofu" = {
      content = lib.generators.toJSON { } cfg.settings;
      path = "${config.home.homeDirectory}/.config/opentofu/credentials.tfrc.json";
    };
  };
}
