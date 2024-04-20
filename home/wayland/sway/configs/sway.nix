{pkgs, ...}: {
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      bars = [];
      modifier = "Mod1";
      terminal = "kitty";
      startup = [
        {command = "ssb";}
        {command = "ruin";}
      ];
      /*
        keybindings = {
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+m" = ''
          exec swaymsg -t get_workspaces \
            | jq -r 'map(.num) | max + 1' \
            | xargs -I {} swaymsg move container to workspace number {}
        '';
      };
      */
    };
  };
}
