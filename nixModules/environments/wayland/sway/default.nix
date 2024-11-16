{ lib, config, username, window-manager, ... }:
let inherit (config) terminal seto colorscheme ydotool audio;
in {
  config = lib.mkIf (window-manager.enable && window-manager.name == "sway") {
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
          bars = [ ] ++ (lib.optional (config.statusBar.enable) {
            command = "${config.statusBar.program}";
          });
          modifier = "Mod1";
          gaps.outer = 7;

          output = lib.mapAttrs (name: value: {
            position =
              "${toString value.position.x} ${toString value.position.y}";
            resolution = "${toString value.dimensions.width}x${
                toString value.dimensions.height
              }@${toString value.refresh}Hz";
            scale = "${toString value.scale}";
          }) config.outputs;

          input."9011:26214:ydotoold_virtual_device" =
            lib.mkIf config.ydotool.enable { "accel_profile" = "flat"; };

          startup = [ ] ++ lib.optional (config.terminal.enable) {
            command = "sway workspace 1; ${terminal.program}";
          } ++ lib.optional (config.wallpaper.enable) {
            command = "${config.wallpaper.program} ${config.wallpaper.path}";
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
          } // lib.optionalAttrs (config.terminal.enable) {
            "${modifier}+Shift+Return" = "exec ${config.terminal.program}";
          } // lib.optionalAttrs (config.launcher.enable) {
            "${modifier}+S" = "exec ${config.launcher.program}";
          };
        };
      };

    };
  };
}
