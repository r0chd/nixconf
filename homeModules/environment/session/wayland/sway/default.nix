{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.environment;
in
{
  config = lib.mkIf (cfg.session == "Wayland") {
    home.packages = [ pkgs.autotiling-rs ];
    wayland.windowManager.sway = {
      enable = true;
      extraConfig = ''
        default_border pixel 2
      '';
      config = rec {
        defaultWorkspace = "workspace number 10";

        bars =
          [ ]
          ++ (lib.optional (cfg.statusBar.enable) {
            command = "${cfg.statusBar.program}";
          });
        modifier = "Mod1";
        gaps.outer = 7;

        startup =
          [ { command = "autotiling-rs"; } ]
          ++ lib.optional (cfg.terminal.enable) {
            command = "sway workspace 1; uwsm app ${cfg.terminal.program}";
          }
          ++ lib.optional (cfg.wallpaper.enable) {
            command = "uwsm app -- ${cfg.wallpaper.program} ${cfg.wallpaper.path}";
          };

        keybindings =
          {
            "${modifier}+Shift+c" = "kill";

            "${modifier}+1" = "workspace 1";
            "${modifier}+2" = "workspace 2";
            "${modifier}+3" = "workspace 3";
            "${modifier}+4" = "workspace 4";
            "${modifier}+5" = "workspace 5";
            "${modifier}+6" = "workspace 6";
            "${modifier}+7" = "workspace 7";
            "${modifier}+8" = "workspace 8";
            "${modifier}+9" = "workspace 9";
            "${modifier}+0" = "workspace 10";

            "${modifier}+Shift+1" = "move container to workspace number 1; workspace 1";
            "${modifier}+Shift+2" = "move container to workspace number 2; workspace 2";
            "${modifier}+Shift+3" = "move container to workspace number 3; workspace 3";
            "${modifier}+Shift+4" = "move container to workspace number 4; workspace 4";
            "${modifier}+Shift+5" = "move container to workspace number 5; workspace 5";
            "${modifier}+Shift+6" = "move container to workspace number 6; workspace 6";
            "${modifier}+Shift+7" = "move container to workspace number 7; workspace 7";
            "${modifier}+Shift+8" = "move container to workspace number 8; workspace 8";
            "${modifier}+Shift+9" = "move container to workspace number 9; workspace 9";
            "${modifier}+Shift+0" = "move container to workspace number 10; workspace 10";

            "${modifier}+n" = "workspace prev_on_output";
            "${modifier}+m" = "workspace next_on_output";

            "${modifier}+Shift+n" = "move container to workspace prev_on_output; workspace prev_on_output";
            "${modifier}+Shift+m" = "move container to workspace next_on_output; workspace next_on_output";

            "${modifier}+h" = "focus output left";
            "${modifier}+j" = "focus output down";
            "${modifier}+k" = "focus output up";
            "${modifier}+l" = "focus output right";

            "${modifier}+Shift+h" = "move container to output left; focus output left";
            "${modifier}+Shift+j" = "move container to output down; focus output down";
            "${modifier}+Shift+k" = "move container to output up; focus output up";
            "${modifier}+Shift+l" = "move container to output right; focus output right";

            "${modifier}+up" = "focus up";
            "${modifier}+down" = "focus down";
            "${modifier}+left" = "focus left";
            "${modifier}+right" = "focus right";

            "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            "XF86AudioRaiseVolume" = "exec pamixer -i 5";
            "XF86AudioLowerVolume" = "exec pamixer -d 5";
          }
          // lib.optionalAttrs config.programs.seto.enable {
            "Print" = ''exec uwsm app -- grim -g "$(seto -r)" - | wl-copy -t image/png'';
          }
          // lib.optionalAttrs config.programs.seto.enable {
            "${modifier}+g" =
              ''exec "uwsm app -- ydotool mousemove -a $(seto -f "%x %y") && ydotool click 0xC0"'';
          }
          // lib.optionalAttrs (cfg.terminal.enable) {
            "${modifier}+Shift+Return" = "exec uwsm app ${cfg.terminal.program}";
          }
          // lib.optionalAttrs (cfg.launcher.enable) {
            "${modifier}+S" = "exec uwsm app ${cfg.launcher.program}";
          };
      };
    };
  };
}
