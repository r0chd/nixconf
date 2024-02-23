{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      mainBar = {
        layer = "bottom";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [/*"backlight"*/ "pulseaudio" "memory" "cpu" "network"];
        "hyprland/workspaces" = {
          format = "{icon}";
          tooltip = false;
          all-outputs = true;
          format-icons = {
            active = "";
            default = "";
          };
        };
        clock = {
          format = " {:%H:%M}";
        };
        /*
        backlight = {
          device = "intel_backlight";
          format = "{icon}{percentage}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        */
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          tooltip = false;
          format-icons = {
            headphone = "";
            default = ["" "" "󰕾" "󰕾" "󰕾" "" "" ""];
          };
          scroll-step = 1;
        };
        memory = {
          interval = 5;
          format = " {percentage}%";
        };
        cpu = {
          interval = 5;
          format = " {usage}%";
        };
        network = {
          interface = "wlan0";
          format = "{ifname}";
          format-wifi = "  {essid}";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-disconnected = "󰖪 No Network";
          tooltip = false;
        };
      };
    };
    style = ''
      * {
        border: none;
        font-family: 'JetBrains Mono';
        font-size: 16px;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
        min-height: 30px;
      }

      window#waybar {
        background-color: #140f21;
      }

      #workspaces {
        border-radius: 10px;
        background-color: #11111b;
        color: #b4befe;
        margin-right: 15px;
        padding-left: 10px;
        padding-right: 10px;
        margin-left: 10px;
        margin-top: 4px;
        margin-bottom: 3px;
      }

      #workspaces button {
        background: #11111b;
        color: #b4befe;
      }

      #clock, #backlight, #pulseaudio, #network, #memory, #cpu {
        background: transparent;
        color: #cdd6f4;
        padding-left: 10px;
        padding-right: 10px;
        margin-right: 15px;
        margin-top: 4px;
        margin-bottom: 3px;
      }

      #backlight, #memory {
        border-top-right-radius: 0;
        border-bottom-right-radius: 0;
        padding-right: 5px;
        margin-right: 0
      }

      #pulseaudio, #cpu {
        border-top-left-radius: 0;
        border-bottom-left-radius: 0;
        padding-left: 5px;
      }

      #clock {
        margin-right: 0;
      }
    '';
  };
}
