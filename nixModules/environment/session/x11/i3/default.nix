{
  lib,
  config,
  ...
}:
let
  cfg = config.environment;
in
{
  config = lib.mkIf (cfg.session == "X11") {
    services.xserver = {
      windowManager.i3.enable = true;
    };
  };
}
