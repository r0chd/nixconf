{ config, lib, ... }:
{
  imports = [ ./i3 ];

  config = lib.mkIf (config.window-manager.enable && config.window-manager.backend == "X11") {
    services.xserver = {
      enable = true;
      desktopManager.xterm.enable = lib.mkDefault false;
    };
  };
}
