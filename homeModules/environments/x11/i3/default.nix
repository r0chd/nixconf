{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.window-manager.enable && config.window-manager.name == "i3") {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };
}
