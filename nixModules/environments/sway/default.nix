{
  inputs,
  conf,
  pkgs,
  lib,
}: let
  inherit (conf) username terminal seto colorscheme;
in {
  security.polkit.enable = true;
  home-manager.users."${username}".wayland.windowManager.sway = {
    enable = true;
    extraConfig = let
      inherit (colorscheme) accent inactive;
    in ''
      default_border pixel 2
      client.unfocused ${inactive} ${inactive} ${inactive} ${inactive}
      client.focused ${accent} ${accent} ${accent} ${accent}
    '';
    config = rec {
      bars =
        []
        ++ (lib.optional (conf ? statusBar) {command = "${conf.statusBar}";});
      modifier = "Mod1";
      gaps.outer = 7;
      input."9011:26214:ydotoold_virtual_device" = {
        "accel_profile" = "flat";
      };
      startup =
        []
        ++ lib.optional (conf ? terminal) {command = "sway workspace 1; ${terminal}";}
        ++ lib.optional conf.ruin {command = "ruin nix";};

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

          "${modifier}+n" = "workspace prev";
          "${modifier}+m" = "workspace next";

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

          "${modifier}+Shift+n" = "move container to workspace prev; workspace prev";
          "${modifier}+Shift+m" = "move container to workspace next; workspace next";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

          "XF86AudioRaiseVolume" = "exec pamixer -i 5";
          "XF86AudioLowerVolume" = "exec pamixer -d 5";
        }
        // lib.optionalAttrs (conf ? browser) {
          "${modifier}+Shift+b" = "exec ${conf.browser}";
        }
        // lib.optionalAttrs seto {
          "Print" = "exec grim -g \"$(seto -r)\" - | wl-copy -t image/png";
        }
        // lib.optionalAttrs (conf ? terminal) {
          "${modifier}+Shift+Return" = "exec ${conf.terminal}";
        };
    };
  };
}
