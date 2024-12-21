{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.window-manager.enable && config.window-manager.name == "sway") {
    programs.sway = {
      enable = false;
      extraOptions = [ "--unsupported-gpu" ];
    };
  };
}
