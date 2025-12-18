{ config, lib, ... }:
let
  cfg = config.environment.statusBar;
in
{
  config = lib.mkIf cfg.enable {
    services.network-manager-applet = {
      enable = true;
    };
  };
}
