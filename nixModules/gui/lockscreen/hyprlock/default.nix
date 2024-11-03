{ config, std, lib, username, ... }:
let
  inherit (config) colorscheme;
  inherit (colorscheme) text background1;
in {
  config = lib.mkIf
    (config.lockscreen.enable && config.lockscreen.program == "hyprlock") {
      security.pam.services.hyprlock = { };
      home-manager.users."${username}" = {
        programs.hyprlock = {
          enable = true;
          settings = {
            general = {
              hide_cursor = true;
              no_fade_in = false;
              disable_loading_bar = true;
              grace = 0;
            };
            background = [{
              monitor = "";
              color = "rgb(${std.conversions.hexToRGBString "," background1})";
              brightness = 0.2;
            }];
            input-field = [{
              monitor = "";
              size = "250, 60";
              outline_thickness = 2;
              dots_size = 0.2;
              dots_spacing = 0.2;
              dots_center = true;
              outer_color = "rgb(0, 0, 0, 0)";
              inner_color = "rgba(0, 0, 0, 0.5)";
              font_color = "rgb(${text})";
              fade_on_empty = false;
              placeholder_text =
                ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
              hide_input = false;
              position = "0, -120";
              halign = "center";
              valign = "center";
            }];
            label = [{
              monitor = "";
              text = "$TIME";
              font_size = 120;
              position = "0, 80";
              valign = "center";
              halign = "center";
            }];
          };
        };
      };
    };
}
