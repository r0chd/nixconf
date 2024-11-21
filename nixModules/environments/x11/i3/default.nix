{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.window-manager.enable && config.window-manager.name == "i3") {
    services.xserver = {
      windowManager.i3.enable = true;
    };
  };
}
