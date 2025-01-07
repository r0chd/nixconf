{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.environment;
in
{
  imports = [ inputs.niri.homeModules.niri ];

  config = lib.mkIf (cfg.session == "Wayland") {
    home.packages = with pkgs; [ xwayland-satellite ];
    programs.niri = {
      enable = true;
      settings = {
        input = {
          keyboard = {
            repeat-delay = 600;
            repeat-rate = 25;
          };

          touchpad = {
            tap = true;
            accel-profile = "flat";
            natural-scroll = false;
          };

          mouse = {
            accel-profile = "flat";
            natural-scroll = false;
          };
        };

        hotkey-overlay.skip-at-startup = true;

        window-rules = [
          {
            geometry-corner-radius =
              let
                radius = 8.0;
              in
              {
                bottom-left = radius;
                bottom-right = radius;
                top-left = radius;
                top-right = radius;
              };
            clip-to-geometry = true;
          }
        ];

        animations = { };

        environment = {
          DISPLAY = ":0";
        };

        prefer-no-csd = true;

        layout = {
          border = {
            width = 1;
          };

          preset-column-widths = [
            { proportion = 0.25; }
            { proportion = 0.5; }
            { proportion = 0.75; }
          ];

          default-column-width.proportion = 1.0;

          gaps = 16;

          center-focused-column = "never";
        };

        spawn-at-startup = [
          {
            command = [
              "uwsm"
              "finalize"
              "FINALIZED=\"I'm here\""
              "WAYLAND_DISPLAY"
            ];
          }

          {
            command = [
              "uwsm"
              "app"
              "xwayland-satellite"
            ];
          }
          {
            command = lib.mkIf cfg.statusBar.enable [
              "uwsm"
              "app"
              "${cfg.statusBar.program}"
            ];
          }
          {
            command = lib.mkIf cfg.terminal.enable [
              "uwsm"
              "app"
              "${cfg.terminal.program}"
            ];
          }
          {
            command = lib.mkIf cfg.notifications.enable [
              "uwsm"
              "app"
              "${cfg.notifications.program}"
            ];
          }
          {
            command = lib.mkIf cfg.wallpaper.enable [
              "uwsm"
              "app"
              "--"
              "${cfg.wallpaper.program}"
              "${cfg.wallpaper.path}"
            ];
          }
        ];

        animations = {
          enable = true;
        };

        binds = {
          "XF86MonBrightnessUp".action.spawn = [
            "brightnessctl"
            "set"
            "+5%"
          ];
          "XF86MonBrightnessDown".action.spawn = [
            "brightnessctl"
            "set"
            "5%-"
          ];
          "XF86AudioRaiseVolume".action.spawn = [
            "pamixer"
            "-i"
            "5"
          ];
          "XF86AudioLowerVolume".action.spawn = [
            "pamixer"
            "-d"
            "5"
          ];
          "Print".action.spawn = [
            "uwsm"
            "app"
            "--"
            "grim -g \"$(seto -r)\" - | wl-copy"
          ];

          "Alt+G".action.spawn = [
            "uwsm"
            "app"
            "--"
            "bash"
            "-c"
            "ydotool mousemove -a $(seto -f $'%X %Y') && ydotool click 0xC0"
          ];

          "Alt+Q".action.spawn = [
            "uwsm"
            "stop"
          ];

          "Alt+Shift+Return".action.spawn = [
            "uwsm"
            "app"
            "${cfg.terminal.program}"
          ];

          "Alt+S".action.spawn = [
            "uwsm"
            "app"
            "${cfg.launcher.program}"
          ];

          "Alt+0".action.focus-workspace = 10;
          "Alt+1".action.focus-workspace = 1;
          "Alt+2".action.focus-workspace = 2;
          "Alt+3".action.focus-workspace = 3;
          "Alt+4".action.focus-workspace = 4;
          "Alt+5".action.focus-workspace = 5;
          "Alt+6".action.focus-workspace = 6;
          "Alt+7".action.focus-workspace = 7;
          "Alt+8".action.focus-workspace = 8;
          "Alt+9".action.focus-workspace = 9;

          "Alt+Shift+0".action.move-column-to-workspace = 10;
          "Alt+Shift+1".action.move-column-to-workspace = 1;
          "Alt+Shift+2".action.move-column-to-workspace = 2;
          "Alt+Shift+3".action.move-column-to-workspace = 3;
          "Alt+Shift+4".action.move-column-to-workspace = 4;
          "Alt+Shift+5".action.move-column-to-workspace = 5;
          "Alt+Shift+6".action.move-column-to-workspace = 6;
          "Alt+Shift+7".action.move-column-to-workspace = 7;
          "Alt+Shift+8".action.move-column-to-workspace = 8;
          "Alt+Shift+9".action.move-column-to-workspace = 9;

          "Alt+N".action.focus-column-left = { };
          "Alt+M".action.focus-column-right = { };

          "Alt+Shift+N".action.move-column-left = { };
          "Alt+Shift+M".action.move-column-right = { };

          "Alt+H".action.focus-monitor-left = { };
          "Alt+L".action.focus-monitor-right = { };

          "Alt+Shift+H".action.move-column-to-monitor-left = { };
          "Alt+Shift+L".action.move-column-to-monitor-right = { };

          "Alt+Shift+C".action.close-window = { };

          "Alt+R".action.switch-preset-column-width = { };
          "Alt+F".action.maximize-column = { };
          "Alt+C".action.center-column = { };

          "Alt+Shift+K".action.set-column-width = "-10%";
          "Alt+Shift+J".action.set-column-width = "+10%";
        };
      };
    };
  };
}
