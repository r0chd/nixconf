{ config, lib, ... }:
let
  cfg = config.environment.notifications;
in
{
  config = lib.mkIf (cfg.enable && cfg.program == "mako") {
    services.mako = {
      enable = true;
      defaultTimeout = 0;
      borderRadius = 5;
    };
  };
}
