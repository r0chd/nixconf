{ inputs, lib, config, username, pkgs, ... }:
let inherit (config) colorscheme;
in {
  config = lib.mkIf
    (config.window-manager.enable && config.window-manager.name == "niri") {
      home-manager.users."${username}" = {
        xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
        imports = [ inputs.niri.homeModules.niri ];
        nixpkgs.overlays = [ inputs.niri.overlays.niri ];
        home.packages = with pkgs; [ xwayland-satellite ];
        programs.niri = {
          enable = true;
          settings = let inherit (colorscheme) accent1 inactive;
          in {
            outputs = lib.mapAttrs (name: value: {
              scale = value.scale;
              mode = {
                width = value.dimensions.width;
                height = value.dimensions.height;
                refresh = value.refresh;
              };
              position = value.position;
            }) config.home-manager.users.${username}.outputs;

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

            window-rules = [{
              geometry-corner-radius = let radius = 8.0;
              in {
                bottom-left = radius;
                bottom-right = radius;
                top-left = radius;
                top-right = radius;
              };
              clip-to-geometry = true;
            }];

            environment = { DISPLAY = ":0"; };

            prefer-no-csd = true;

            layout = {
              border = {
                width = 1;
                active.color = "#${accent1}";
                inactive.color = "#${inactive}";
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
              { command = [ "xwayland-satellite" ]; }
              {
                command = lib.mkIf
                  config.home-manager.users.${username}.statusBar.enable [
                    "${config.home-manager.users.${username}.statusBar.program}"
                  ];
              }
              {
                command =
                  lib.mkIf config.home-manager.users.${username}.terminal.enable
                  [
                    "${config.home-manager.users.${username}.terminal.program}"
                  ];
              }
              {
                command = lib.mkIf
                  config.home-manager.users.${username}.notifications.enable [
                    "${config.home-manager.users.${username}.notifications.program}"
                  ];
              }
              {
                command = lib.mkIf
                  config.home-manager.users.${username}.wallpaper.enable [
                    "${config.home-manager.users.${username}.wallpaper.program}"
                    "${config.home-manager.users.${username}.wallpaper.path}"
                  ];
              }
            ];

            animations = { enable = true; };

            binds = {
              "XF86MonBrightnessUp".action.spawn =
                [ "brightnessctl" "set" "+5%" ];
              "XF86MonBrightnessDown".action.spawn =
                [ "brightnessctl" "set" "5%-" ];
              "XF86AudioRaiseVolume".action.spawn = [ "pamixer" "-i" "5" ];
              "XF86AudioLowerVolume".action.spawn = [ "pamixer" "-d" "5" ];
              "Print".action.spawn =
                [ "bash" "-c" "grim -g $(seto -r) - | wl-copy -t image/png" ];

              "Alt+G".action.spawn = [
                "bash"
                "-c"
                "ydotool mousemove -a $(seto -f $'%x %y') && ydotool click 0xC0"
              ];

              "Alt+Shift+Return".action.spawn =
                [ "${config.home-manager.users.${username}.terminal.program}" ];

              "Alt+S".action.spawn =
                [ "${config.home-manager.users.${username}.launcher.program}" ];

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
    };
}

