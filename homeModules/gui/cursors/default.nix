{
  config,
  lib,
  ...
}:
let
  cfg = config.cursor;
in
{
  options.cursor = {
    enable = lib.mkEnableOption "Cursor";
    themeName = lib.mkOption {
      type = lib.types.str;
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = 40;
    };
    package = lib.mkOption {
      type = lib.types.package;
    };
  };

  config.home.pointerCursor = lib.mkIf config.environment.window-manager.enable {
    gtk.enable = true;
    x11.enable = config.environment.window-manager.backend == "X11";
    hyprcursor = {
      enable = config.environment.window-manager.name == "Hyprland";
      size = cfg.size;
    };
    name = cfg.themeName;
    size = cfg.size;
    package = cfg.package;
  };
}
