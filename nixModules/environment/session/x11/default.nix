{ config, lib, ... }:
let
  cfg = config.environment;
in
{
  imports = [ ./i3 ];

  config = lib.mkIf (cfg.session == "X11") {
    services = {
      xserver = {
        enable = false;
        desktopManager.xterm.enable = lib.mkDefault false;
      };
      displayManager.defaultSession = "none+${config.window-manager.name}";
    };
  };
}
