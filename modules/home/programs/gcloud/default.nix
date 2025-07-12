{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.gcloud;
in
{
  options.programs.gcloud = {
    enable = lib.mkEnableOption "gcloud";
    package = lib.mkPackageOption pkgs "google-cloud-sdk-gce" { };
    authFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."gcloud/application_default_credentials.json" = lib.mkIf (cfg.authFile != null) {
      source = cfg.authFile;
    };
  };
}
