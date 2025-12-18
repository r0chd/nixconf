{
  config,
  pkgs,
  profile,
  lib,
  ...
}:
let
  cfg = config.environment.statusBar;
  inherit (lib) types;
  inherit (config.lib.stylix.colors) withHashtag;
  inherit (config.stylix) fonts;
in
{
  imports = [
    ./nm-applet.nix
    ./blueman-applet.nix
  ];

  options.environment.statusBar.enable = lib.mkOption {
    type = types.bool;
    default = profile == "desktop";
  };

  config.programs.waybar = {
    inherit (cfg) enable;
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

        "custom/idle-inhibit" = {
          interval = 1;
          exec = pkgs.writeShellScript "mox notify status" ''
            INHIBITED="<span size='large' color='${withHashtag.base0A}'>󱫞</span>"
            UNINHIBITED="<span size='large' color='${withHashtag.base0D}'>󱎫</span>"

            if ${pkgs.moxidle}/bin/moxidlectl inhibit state | grep -q "uninhibited" ; then echo $UNINHIBITED; else echo $INHIBITED; fi
          '';

          on-click = "${pkgs.moxidle}/bin/moxidlectl inhibit toggle";
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
      * {
        border: none;
        font-family: '${fonts.sansSerif.name}';
        font-weight: 500;
        min-height: 0;
      }

      #waybar {
        background: ${withHashtag.base01};
        padding-left: 1.5px;
        padding-right: 1.5px;
      }

      #custom-nix, #workspaces, #window, #pulseaudio, #cpu, #memory, #clock, #tray, #network, #battery, #backlight {
        margin: 7px;
        padding: 5px;
        padding-left: 8px;
        padding-right: 8px;
        border-radius: 4px;
        background: ${withHashtag.base02};
      }

      #custom-idle-inhibit {
        min-width: 30px; 
        background: ${withHashtag.base02};
        padding: 5px;
        padding-left: 8px;
        padding-right: 8px;
        margin: 7px;
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
        background: ${withHashtag.base02};
        border: ${withHashtag.base01};
        padding: 0 3px;
      }

      #workspaces button.active {
        color: ${withHashtag.base0E};  /* Active workspace */
      }

      #workspaces button.empty {
        color: ${withHashtag.base04};  /* Empty workspaces */
      }

      #workspaces button.default {
        color: ${withHashtag.base04};
      }

      #workspaces button.special {
        color: ${withHashtag.base0C};
      }

      #workspaces button.urgent {
        color: ${withHashtag.base08};
      }

      #custom-sep {
        color: ${withHashtag.base03};
      }

      #cpu {
        color: ${withHashtag.base0C};
      }

      #memory {
        color: ${withHashtag.base0F};
      }

      #clock {
        color: ${withHashtag.base07};
      }

      #mpris {
        color: ${withHashtag.base06};
      }

      #network {
        color: ${withHashtag.base0C};
      }

      #network.disconnected {
        color: ${withHashtag.base09};
      }

      #window {
        color: ${withHashtag.base0D};
      }

      #custom-nix {
        color: ${withHashtag.base0D};
      }

      #pulseaudio {
        color: ${withHashtag.base0B};
      }

      #battery {
        color: ${withHashtag.base09};
      }

      #backlight {
        color: ${withHashtag.base06};
      }
    '';
  };
}
