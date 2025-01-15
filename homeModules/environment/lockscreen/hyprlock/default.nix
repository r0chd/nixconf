{
  config,
  lib,
  ...
}:
let
  cfg = config.environment.screenIdle.lockscreen;
in
{
  config = lib.mkIf (cfg.enable && cfg.program == "hyprlock") {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          no_fade_in = false;
          disable_loading_bar = true;
          grace = 0;
        };
        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 120;
            position = "0, 80";
            valign = "center";
            halign = "center";
          }
        ];
      };
    };
  };
}
