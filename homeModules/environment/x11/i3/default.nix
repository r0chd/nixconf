{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.environment;
in
{
  config = lib.mkIf (cfg.window-manager.enable && cfg.window-manager.name == "i3") {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
