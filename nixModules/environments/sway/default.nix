{ conf, lib, config }:
let inherit (conf) username terminal seto colorscheme ydotool audio;
in {
  config = lib.mkIf
    (config.window-manager.enable && config.window-manager.name == "sway") {
      security.polkit.enable = true;
      home-manager.users."${username}" = {
        wayland.windowManager.sway = {
          enable = true;
          extraConfig = let inherit (colorscheme) accent1 inactive;
          in ''
            default_border pixel 2
            client.unfocused ${inactive} ${inactive} ${inactive} ${inactive}
            client.focused ${accent1} ${accent1} ${accent1} ${accent1}
          '';
          config = rec {
            bars = [ ] ++ (lib.optional (conf.statusBar.enable) {
              command = "${conf.statusBar.program}";
            });
            modifier = "Mod1";
            gaps.outer = 7;
            input."9011:26214:ydotoold_virtual_device" = {
              "accel_profile" = "flat";
            };
            startup = [ ] ++ lib.optional (conf.terminal.enable) {
              command = "sway workspace 1; ${terminal.program}";
            } ++ lib.optional (conf.wallpaper.enable) {
              command = "${conf.wallpaper.program} ${conf.wallpaper.path}";
            };

            keybindings = {
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

              "${modifier}+n" = "workspace prev";
              "${modifier}+m" = "workspace next";

              "${modifier}+Shift+1" =
                "move container to workspace number 1; workspace 1";
              "${modifier}+Shift+2" =
                "move container to workspace number 2; workspace 2";
              "${modifier}+Shift+3" =
                "move container to workspace number 3; workspace 3";
              "${modifier}+Shift+4" =
                "move container to workspace number 4; workspace 4";
              "${modifier}+Shift+5" =
                "move container to workspace number 5; workspace 5";
              "${modifier}+Shift+6" =
                "move container to workspace number 6; workspace 6";
              "${modifier}+Shift+7" =
                "move container to workspace number 7; workspace 7";
              "${modifier}+Shift+8" =
                "move container to workspace number 8; workspace 8";
              "${modifier}+Shift+9" =
                "move container to workspace number 9; workspace 9";
              "${modifier}+Shift+0" =
                "move container to workspace number 10; workspace 10";

              "${modifier}+Shift+n" =
                "move container to workspace prev; workspace prev";
              "${modifier}+Shift+m" =
                "move container to workspace next; workspace next";

              "${modifier}+h" = "focus left";
              "${modifier}+j" = "focus down";
              "${modifier}+k" = "focus up";
              "${modifier}+l" = "focus right";

              "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
              "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            } // lib.optionalAttrs audio.enable {
              "XF86AudioRaiseVolume" = "exec pamixer -i 5";
              "XF86AudioLowerVolume" = "exec pamixer -d 5";
            } // lib.optionalAttrs seto.enable {
              "Print" = ''exec grim -g "$(seto -r)" - | wl-copy -t image/png'';
            } // lib.optionalAttrs (seto.enable && ydotool.enable) {
              "${modifier}+g" = ''
                exec "ydotool mousemove -a $(seto -f "%x %y") && ydotool click 0xC0"'';
            } // lib.optionalAttrs (conf.terminal.enable) {
              "${modifier}+Shift+Return" = "exec ${conf.terminal.program}";
            } // lib.optionalAttrs (conf.launcher.enable) {
              "${modifier}+S" = "exec ${conf.launcher.program}";
            };
          };
        };

        services.swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "loginctl lock-session";
            }
            {
              event = "lock";
              command = "${conf.lockscreen.program}";
            }
          ];
        };
      };
    };
}
