{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.window-manager.enable && config.window-manager.name == "niri") {
    programs.niri.enable = true;
  };
}
