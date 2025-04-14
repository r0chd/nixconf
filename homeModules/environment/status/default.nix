{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
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
          "mpris"
          "custom/sep"
          "network"
          "pulseaudio"
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

        mpris = {
          format = "  {title}";
          max-length = 30;
        };

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
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
}
