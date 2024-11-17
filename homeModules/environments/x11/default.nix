{ config, lib, ... }: {
  config = lib.mkIf
    (config.window-manager.enable && config.window-manager.backend == "X11")
    { };
}
