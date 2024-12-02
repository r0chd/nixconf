{ config, lib, ... }:
let
  cfg = config.environment;
in
{
  imports = [ ./i3 ];

  config =
    lib.mkIf (cfg.window-manager.enable && cfg.window-manager.backend == "X11")
      {
      };
}
