{
  config,
  pkgs,
  profile,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  programs.waybar = {
    enable = profile == "desktop";
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
          "custom/idle-inhibit"
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

        "custom/idle-inhibit" = {
          interval = 1;
          exec = pkgs.writeShellScript "idle-inhibit" ''
            LOCKFILE="/tmp/idle-inhibit.lock"
            INHIBITED_ICON="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0A}'>󱫞</span>"
            UNINHIBITED_ICON="<span size='large' color='${config.lib.stylix.colors.withHashtag.base0D}'>󱎫</span>"

            if [ -f "$LOCKFILE" ]; then
                echo "$INHIBITED_ICON"
            else
                echo "$UNINHIBITED_ICON"
            fi
          '';

          on-click =
            #sh
            ''
              LOCKFILE="/tmp/idle-inhibit.lock"

              if [ -f "$LOCKFILE" ]; then
                rm "$LOCKFILE"
              else 
                touch "$LOCKFILE"
                systemd-inhibit \
                  --who="waybar" \
                  --what=idle \
                  --why="Prevent sleep while lockfile exists" \
                  bash -c "${pkgs.inotify-tools}/bin/inotifywait -e delete \"$LOCKFILE\"" \
                  &> /dev/null &
              fi

            '';
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
        background: ${base01};
        padding-left: 1.5px;
        padding-right: 1.5px;
      }

      #custom-nix, #workspaces, #window, #pulseaudio, #cpu, #memory, #clock, #tray, #network, #battery, #backlight {
        margin: 7px;
        padding: 5px;
        padding-left: 8px;
        padding-right: 8px;
        border-radius: 4px;
        background: ${base02};
      }

      #custom-idle-inhibit {
        min-width: 30px; 
        background: ${base02};
        padding: 5px;
        padding-left: 8px;
        padding-right: 8px;
        margin: 7px;
        border-radius: 4px;
      }

      #custom-moxnotify-inhibit,
      #custom-moxnotify-history,
      #custom-moxnotify-muted {
        min-width: 30px; 
        background: ${base02};
        padding: 5px;
        margin-top: 7px;
        margin-bottom: 7px;
      }

      #custom-moxnotify-inhibit {
        margin-left: 7px;
        border-radius: 4px 0 0 4px;
        padding-right: 0;
        padding-left: 8px;
      }

      #custom-moxnotify-muted {
        margin-right: 7px;
        border-radius: 0 4px 4px 0;
        padding-left: 0;
        padding-right: 8px;
      }

      #workspaces {
        margin: 7px;
        padding: 4.5px;
      }

      #workspaces button {
        padding: 0 2px;
      }

      #workspaces button:hover {
        background: ${base02};
        border: ${base01};
        padding: 0 3px;
      }

      #workspaces button.active {
        color: @mauve;  /* Active workspace */
      }

      #workspaces button.empty {
        color: ${base04};  /* Empty workspaces */
      }

      #workspaces button.default {
        color: ${base04};
      }

      #workspaces button.special {
        color: @sapphire;
      }

      #workspaces button.urgent {
        color: @red;
      }

      #custom-sep {
        color: ${base03};
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
