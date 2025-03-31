{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ngrok;
in
{
  options.services.ngrok = {
    enable = lib.mkEnableOption "ngrok";
    package = lib.mkPackageOption pkgs "ngrok" { };
    agent = {
      authtoken = lib.mkOption { type = lib.types.nullOr lib.types.str; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    sops.templates."ngrok.yml" = {
      path = "${config.home.homeDirectory}/.config/ngrok/ngrok.yml";
      content = ''
        version: 3
        agent:
            authtoken: ${cfg.agent.authtoken}
      '';
    };
  };
}
