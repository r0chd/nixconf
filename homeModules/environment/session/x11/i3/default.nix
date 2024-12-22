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
  config = lib.mkIf (cfg.session == "X11") {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
