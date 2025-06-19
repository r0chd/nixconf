{
  config,
  pkgs,
  system_type,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  programs.waybar = {
    enable = system_type == "desktop";
    systemd.enable = true;
    settings = {
      mainBar = {
        "layer" = "top";
        "position" = "top";
        "modules-left" = [
          "custom/nix"
          "hyprland/workspaces"
          "niri/workspaces"
          "custom/sep"
          "cpu"
          "memory"
        ];
        "modules-center" = [ "clock" ];
        "modules-right" = [
          "battery"
          "network"
          "pulseaudio"
          "backlight"
          "custom/sep"
          "custom/moxnotify-inhibit"
          "custom/moxnotify-history"
          "custom/moxnotify-muted"
          "custom/sep"
          "tray"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          sort-by-name = true;
          format = "{icon}";
          format-icons = {
            empty = "";
            active = "";
            default = "";
          };
          icon-size = 9;
          persistent-workspaces = {
            "*" = 6;
          };
        };
        "niri/workspaces" = {
          all-outputs = false;
          current-only = true;
          format = "{index}";
          disable-click = true;
          disable-markup = true;
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = " {capacity}% ";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        cpu = {
          interval = 1;
          format = "  {usage}%";
          max-length = 10;
        };
        network = {
          format-wifi = "  {bandwidthTotalBytes}";
          format-ethernet = "eth {ipaddr}/{cidr}";
          format-disconnected = "net none";
          tooltip-format = "{ifname} via {gwaddr}";
          tooltip-format-wifi = "Connected to: {essid} {frequency} - ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          interval = 5;
        };
        memory = {
          interval = 2;
          format = "  {used:0.2f}G";
        };
        hyprland.window.format = "{class}";
        tray = {
          icon-size = 20;
          spacing = 8;
        };
        "custom/sep".format = "|";

        clock.format = "  {:%I:%M %p}";

        "custom/nix".format = "<span size='large'> </span>";

        "custom/moxnotify-inhibit" = {
          interval = 1;
          exec = pkgs.writeShellScript "mox notify status" ''
            COUNT=$(mox notify waiting)
            INHIBITED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0F}'>  $( [ $COUNT -gt 0 ] && echo "$COUNT" )</span>"
            UNINHIBITED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0F}'>  </span>"

            if mox notify inhibit state | grep -q "uninhibited" ; then echo $UNINHIBITED; else echo $INHIBITED; fi
          '';

          on-click = "mox notify inhibit toggle";
        };

        "custom/moxnotify-muted" = {
          interval = 1;
          exec = pkgs.writeShellScript "mox notify status" ''
            MUTED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base08}'>  </span>"       
            UNMUTED="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0B}'>  </span>"     

            if mox notify mute state | grep -q "unmuted" ; then echo $UNMUTED; else echo $MUTED; fi
          '';

          on-click = "mox notify mute toggle";
        };

        "custom/moxnotify-history" = {
          interval = 1;
          exec = pkgs.writeShellScript "mox notify status" ''
            HISTORY_SHOWN="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0D}'>  </span>"   
            HISTORY_HIDDEN="<span size='large' color='${config.lib.stylix.colors.withHashtag.base03}'>  </span>"  

            if mox notify history state | grep -q "hidden" ; then echo $HISTORY_HIDDEN; else echo $HISTORY_SHOWN; fi
          '';

          on-click = "mox notify history toggle";
        };

        pulseaudio = {
          format = "<span size='large'>󰕾 </span> {volume}%";
          format-muted = "  0%";
          on-click = "pavucontrol";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = {
            default = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
        };
      };
    };
    style = ''
      @define-color base      ${base02};
      @define-color crust     ${base01};
      @define-color surface0  ${base03};
      @define-color surface2  ${base04};
      @define-color overlay0  ${base04};
      @define-color blue      ${base0D};
      @define-color lavender  ${base07};
      @define-color sapphire  ${base0C};
      @define-color teal      ${base0C};
      @define-color green     ${base0B};
      @define-color peach     ${base09};
      @define-color red       ${base08};
      @define-color mauve     ${base0E};
      @define-color flamingo  ${base0F};
      @define-color rosewater ${base06};

      * {
        border: none;
        font-family: '${sansSerif.name}';
        font-weight: 500;
        min-height: 0;
      }

      #waybar {
        background: @crust;
        padding-left: 1.5px;
        padding-right: 1.5px;
      }

      #custom-nix, #workspaces, #window, #pulseaudio, #cpu, #memory, #clock, #tray, #network, #battery, #backlight {
        margin: 7px;
        padding: 5px;
        padding-left: 8px;
        padding-right: 8px;
        border-radius: 4px;
        background: @base;
      }

      #custom-moxnotify-inhibit,
      #custom-moxnotify-history,
      #custom-moxnotify-muted {
        min-width: 30px; 
        background: @base;
        padding: 5px;
        padding-left: 8px;
        padding-right: 8px;
        border-radius: 4px;
      }

      #workspaces {
        margin: 7px;
        padding: 4.5px;
      }

      #workspaces button {
        padding: 0 2px;
      }

      #workspaces button:hover {
        background: @base;
        border: @crust;
        padding: 0 3px;
      }

      #workspaces button.active {
        color: @mauve;  /* Active workspace */
      }

      #workspaces button.empty {
        color: @surface2;  /* Empty workspaces */
      }

      #workspaces button.default {
        color: @overlay0;
      }

      #workspaces button.special {
        color: @sapphire;
      }

      #workspaces button.urgent {
        color: @red;
      }

      #custom-sep {
        color: @surface0;
      }

      #cpu {
        color: @teal;
      }

      #memory {
        color: @flamingo;
      }

      #clock {
        color: @lavender;
      }

      #mpris {
        color: @rosewater;
      }

      #network {
        color: @sapphire;
      }

      #network.disconnected {
        color: @peach;
      }

      #window {
        color: @blue;
      }

      #custom-nix {
        color: @blue;
      }

      #pulseaudio {
        color: @green;
      }

      #battery {
        color: @peach;
      }

      #backlight {
        color: @rosewater;
      }

    '';
  };
}
