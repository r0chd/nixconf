{
  config,
  lib,
  ...
}:
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

  config.home.pointerCursor = lib.mkIf config.window-manager.enable {
    gtk.enable = true;
    x11.enable = config.window-manager.backend == "X11";
    hyprcursor = {
      enable = config.window-manager.name == "Hyprland";
      size = config.cursor.size;
    };
    name = config.cursor.themeName;
    size = config.cursor.size;
    package = config.cursor.package;
  };
}
