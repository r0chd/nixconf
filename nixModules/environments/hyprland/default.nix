{ pkgs, inputs, conf, lib, config }:
let inherit (conf) username audio colorscheme seto ydotool;
in {
  config = lib.mkIf
    (config.window-manager.enable && config.window-manager.name == "Hyprland") {
      environment.systemPackages = with pkgs;
        [
          (writeShellScriptBin "click" ''
            cursorpos=$(hyprctl cursorpos)
            x=$(echo $cursorpos | cut -d "," -f 1)
            y=$(echo $cursorpos | cut -d "," -f 2)
            initial_cursorpos="$x $y"

            ydotool mousemove -a $(seto -f $'%x %y\\n') && ydotool click 0xC0 && ydotool mousemove -a $initial_cursorpos
          '')
        ];
      programs.hyprland.portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

      home-manager.users."${username}".wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        settings = {
          input = {
            monitor =
              [ "eDP-1, 1920x1080, 0x0, 1" "HDMI-A-1, 1920x1080, 1920x0, 1" ];

            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";

            follow_mouse = "1";

            touchpad = {
              disable_while_typing = "false";
              natural_scroll = "no";
            };

            sensitivity = "0"; # -1.0 - 1.0, 0 means no modification.
            accel_profile = "flat";
          };

          general = let inherit (colorscheme) accent1 inactive;
          in {
            "col.active_border" = "rgb(${accent1})";
            "col.inactive_border" = "rgb(${inactive})";

            border_size = 2;
          };

          decoration = {
            rounding = "16";
            drop_shadow = "yes";
            shadow_range = "4";
            shadow_render_power = "3";

            blur.enabled = false;
          };

          debug.disable_logs = false;

          animations = {
            enabled = "true";

            bezier = [
              "overshot, 0.05, 0.9, 0.1, 1.05"
              "smoothOut, 0.36, 0, 0.66, -0.56"
              "smoothIn, 0.25, 1, 0.5, 1"
            ];

            animation = [
              "windows, 1, 5, overshot, slide"
              "windowsOut, 1, 4, smoothOut, slide"
              "windowsMove, 1, 4, default"
              "border, 1, 10, default"
              "fadeDim, 1, 10, smoothIn"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = "yes";
            preserve_split = "yes";
          };

          gestures = { workspace_swipe = "off"; };

          misc = {
            force_default_wallpaper = "0";
            disable_hyprland_logo = "true";
            vfr = "true";
          };

          "$mainMod" = "ALT"; # Mod key

          exec-once = [ ]
            ++ (lib.optional (conf ? statusBar) "${conf.statusBar}")
            ++ (lib.optional (conf ? terminal) "${conf.terminal}")
            ++ lib.optional (conf ? wallpaper && conf.wallpaper ? program
              && conf.wallpaper ? path)
            "${conf.wallpaper.program} ${conf.wallpaper.path}";

          env = [ "HYPRCURSOR_SIZE,24" ];

          bind = [
            # Brightness
            ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

            # Manage workspace
            "$mainMod SHIFT, C, killactive,"
            "$mainMod, F, togglefloating,"
            "$mainMod, H, movefocus, l"
            "$mainMod, L, movefocus, r"
            "$mainMod, K, movefocus, u"
            "$mainMod, J, movefocus, d"

            # Switch workspaces with mainMod + [0-9]
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move to next workspace with mainMod + [M/N]
            "$mainMod, N, workspace, e-1"
            "$mainMod, M, workspace, e+1"

            # Move active window to next workspace with mainMod + [M/N]
            "$mainMod SHIFT, N, movetoworkspace, -1"
            "$mainMod SHIFT, M, movetoworkspace, +1"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"
          ] ++ (lib.optional audio ", XF86AudioRaiseVolume, exec, pamixer -i 5")
            ++ (lib.optional audio ", XF86AudioLowerVolume, exec, pamixer -d 5")
            ++ (lib.optional (conf ? terminal)
              "$mainMod SHIFT, RETURN, exec, ${conf.terminal}")
            ++ (lib.optional seto
              '', Print, exec, grim -g "$(seto -r)" - | wl-copy -t image/png'')
            ++ (lib.optional (seto && ydotool) "$mainMod, G, exec, click")
            ++ (lib.optional (conf ? launcher)
              "$mainMod, S, exec, ${conf.launcher}");

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
      };
    };
}
