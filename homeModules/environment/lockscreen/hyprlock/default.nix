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
          grace = 2;
        };
        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 100;
            position = "0, 80";
            valign = "center";
            halign = "center";
          }
        ];

        input-field = {
          size = "50, 50";
          dots_size = 0.33;
          dots_spacing = 0.15;
        };
      };
    };
  };
}
