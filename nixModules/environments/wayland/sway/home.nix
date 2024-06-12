{
  username,
  term,
  ...
}: {
  home-manager.users."${username}".wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      default_border pixel 2
      client.unfocused 1e1e2e 1e1e2e 1e1e2e 1e1e2e
      client.focused c5a8eb c5a8eb c5a8eb c5a8eb
    '';
    config = rec {
      bars = [];
      modifier = "Mod1";
      terminal = term;
      gaps.outer = 7;
      input."9011:26214:ydotoold_virtual_device" = {
        "accel_profile" = "flat";
      };
      startup = [
        {command = "waystatus";}
        {command = "ruin";}
        {command = "sway workspace 1; ${terminal}";}
      ];
      keybindings = {
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+Return" = "exec ${terminal}";

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

        "${modifier}+n" = "workspace previous";
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

        "${modifier}+Shift+n" = "move container to workspace previous; workspace previous";
        "${modifier}+Shift+m" = "move container to workspace next; workspace next";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";

        "Print" = "exec grim -g \"$(seto -r)\" - | wl-copy -t image/png";
      };
    };
  };
}
