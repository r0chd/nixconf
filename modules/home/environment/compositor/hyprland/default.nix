{
  pkgs,
  lib,
  config,
  platform,
  profile,
  ...
}:
let
  cfg = config.programs.hyprland;
  inherit (lib) types;
in
{
  options.programs.hyprland = {
    enable = lib.mkOption {
      default = profile == "desktop";
      type = types.bool;
    };
    package = lib.mkOption {
      type = types.package;
      default = if platform == "non-nixos" then (config.lib.nixGL.wrap pkgs.hyprland) else pkgs.hyprland;
    };
    layout = lib.mkOption {
      type = types.enum [
        "scrolling"
        "tiling"
      ];
      default = "scrolling";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      inherit (cfg) enable;
      inherit (cfg) package;

      plugins = builtins.attrValues { inherit (pkgs.hyprlandPlugins) hyprscrolling; };

      settings = {
        exec-once = [
          "systemctl --user start hyprpolkitagent"
        ];

        layerrule = [ "noanim, moxnotify" ];

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 2;

          touchpad = {
            disable_while_typing = false;
            natural_scroll = "no";
          };
        };

        ecosystem.no_update_news = true;

        general = {
          border_size = 1;
          layout = "scrolling";
        };

        plugin = {
          hyprscrolling = {
            column_width = 1;
            fullscreen_on_one_column = false;
            focus_fit_method = 1;
          };
        };

        decoration = {
          rounding = 16;

          blur = {
            enabled = true;
          };
        };

        debug.disable_logs = false;

        animations = {
          enabled = true;

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
            "workspaces, 1, 6, default, slidevert"
          ];
        };

        misc = {
          force_default_wallpaper = "0";
          vfr = true;
        };

        "$mainMod" = "ALT"; # Mod key

        bind = [
          ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"

          "$mainMod SHIFT, C, killactive,"
          "$mainMod, O, togglefloating,"

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

          "$mainMod, D, exec, ${pkgs.moxctl}/bin/mox notify focus"

          ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
          ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"

          "$mainMod, q, exec, ${pkgs.uwsm}/bin/uwsm stop"
          ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | wl-copy"
        ]
        ++ lib.optionals (cfg.layout == "scrolling") [
          "$mainMod, F, layoutmsg, fit active"

          "$mainMod, H, layoutmsg, focus l"
          "$mainMod, L, layoutmsg, focus r"
          "$mainMod, J, layoutmsg, focus d"
          "$mainMod, K, layoutmsg, focus u"

          "$mainMod SHIFT, K, movecurrentworkspacetomonitor, u"
          "$mainMod SHIFT, J, movecurrentworkspacetomonitor, d"
          "$mainMod SHIFT, N, movecurrentworkspacetomonitor, l"
          "$mainMod SHIFT, M, movecurrentworkspacetomonitor, r"

          "$mainMod SHIFT, N, layoutmsg, focusmonitor l"
          "$mainMod SHIFT, M, layoutmsg, focusmonitor r"

          "$mainMod SHIFT, L, layoutmsg, swapcol r"
          "$mainMod SHIFT, H, layoutmsg, swapcol l"

          "$mainMod, R, layoutmsg, colresize +conf"
        ]
        ++ lib.optionals (cfg.layout == "tiling") [ ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
