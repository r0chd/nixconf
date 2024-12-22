{ config, lib, ... }:
let
  cfg = config.environment;
in
{
  imports = [ ./i3 ];

  config = lib.mkIf (cfg.session == "X11") {
  };
}
