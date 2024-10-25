{ inputs, conf, lib, config }:
let inherit (conf) username colorscheme;
in {
  config = lib.mkIf
    (config.window-manager.enable && config.window-manager.name == "niri") {
      home-manager.users."${username}" = {
        imports = [ inputs.niri.homeModules.niri ];
        nixpkgs.overlays = [ inputs.niri.overlays.niri ];
        programs.niri = {
          enable = true;
          config = let
            inherit (inputs.niri.lib.kdl) node plain leaf flag;
            inherit (colorscheme) accent1 inactive;
          in [
            (plain "input" [
              (plain "keyboard" [
                (leaf "repeat-delay" 600)
                (leaf "repeat-rate" 25)
              ])

              (plain "touchpad" [ (flag "tap") (leaf "accel-profile" "flat") ])
              (plain "mouse" [ (leaf "accel-profile" "flat") ])
            ])

            (node "output" "eDP-1" [
              (leaf "scale" 1.0)
              (leaf "transform" "normal")
              (leaf "mode" "1920x1080")

              (leaf "position" {
                x = 0;
                y = 0;
              })
            ])

            (node "output" "HDMI-A-1" [
              (leaf "scale" 1.0)
              (leaf "transform" "normal")
              (leaf "mode" "1920x1080")

              (leaf "position" {
                x = 1920;
                y = 0;
              })
            ])

            (flag "prefer-no-csd")
            (plain "layout" [
              (plain "border" [
                (leaf "width" 2)
                (leaf "active-color" "#${accent1}")
                (leaf "inactive-color" "#${inactive}")
              ])

              (plain "preset-column-widths" [
                (leaf "proportion" 0.25)
                (leaf "proportion" 0.5)
                (leaf "proportion" 1.0)
              ])

              (plain "default-column-width" [ (leaf "proportion" 1.0) ])

              (leaf "gaps" 16)

              (leaf "center-focused-column" "never")
            ])

            (lib.optional (conf ? statusBar)
              (leaf "spawn-at-startup" [ "${conf.statusBar}" ]))

            (lib.optional (conf ? terminal)
              (leaf "spawn-at-startup" [ "${conf.terminal}" ]))

            (lib.optional (conf ? wallpaper && conf.wallpaper ? program
              && conf.wallpaper ? path) (leaf "spawn-at-startup"
                [ "${conf.wallpaper.program} ${conf.wallpaper.path}" ]))

            (plain "cursor" [
              # (leaf "xcursor-theme" "default")
              # (leaf "xcursor-size" 24)
            ])

            # Animation settings.
            (plain "animations" [

              # Slow down all animations by this factor. Values below 1 speed them up instead.
              # (leaf "slowdown" 3.0)

              # You can configure all individual animations.
              # Available settings are the same for all of them.
              # - off disables the animation.
              #
              # Niri supports two animation types: easing and spring.
              # You can set properties for only ONE of them.
              #
              # Easing has the following settings:
              # - duration-ms sets the duration of the animation in milliseconds.
              # - curve sets the easing curve. Currently, available curves
              #   are "ease-out-cubic" and "ease-out-expo".
              #
              # Spring animations work better with touchpad gestures, because they
              # take into account the velocity of your fingers as you release the swipe.
              # The parameters are less obvious and generally should be tuned
              # with trial and error. Notably, you cannot directly set the duration.
              # You can use this app to help visualize how the spring parameters
              # change the animation: https://flathub.org/apps/app.drey.Elastic
              #
              # A spring animation is configured like this:
              # - (leaf "spring" { damping-ratio=1.0; stiffness=1000; epsilon=0.0001; })
              #
              # The damping ratio goes from 0.1 to 10.0 and has the following properties:
              # - below 1.0: underdamped spring, will oscillate in the end.
              # - above 1.0: overdamped spring, won't oscillate.
              # - 1.0: critically damped spring, comes to rest in minimum possible time
              #    without oscillations.
              #
              # However, even with damping ratio = 1.0 the spring animation may oscillate
              # if "launched" with enough velocity from a touchpad swipe.
              #
              # Lower stiffness will result in a slower animation more prone to oscillation.
              #
              # Set epsilon to a lower value if the animation "jumps" in the end.
              #
              # The spring mass is hardcoded to 1.0 and cannot be changed. Instead, change
              # stiffness proportionally. E.g. increasing mass by 2x is the same as
              # decreasing stiffness by 2x.

              # Animation when switching workspaces up and down,
              # including after the touchpad gesture.
              (plain "workspace-switch" [
                # (leaf "spring" { damping-ratio=1.0; stiffness=1000; epsilon=0.0001; })
              ])

              # All horizontal camera view movement:
              # - When a window off-screen is focused and the camera scrolls to it.
              # - When a new window appears off-screen and the camera scrolls to it.
              # - When a window resizes bigger and the camera scrolls to show it in full.
              # - And so on.
              (plain "horizontal-view-movement" [
                # (flag "off")
                # (leaf "spring" { damping-ratio=1.0; stiffness=800; epsilon=0.0001; })
              ])

              # Window opening animation. Note that this one has different defaults.
              (plain "window-open" [
                # (leaf "duration-ms" 150)
                # (leaf "curve" "ease-out-expo")

                # Example for a slightly bouncy window opening:
                # (leaf "spring" { damping-ratio=0.8; stiffness=1000; epsilon=0.0001; })
              ])

              # Config parse error and new default config creation notification
              # open/close animation.
              (plain "config-notification-open-close" [
                # (flag "off")
                # (leaf "spring" { damping-ratio=0.6; stiffness=1000; epsilon=0.001; })
              ])
            ])

            (plain "window-rule" [
              (leaf "geometry-corner-radius" 12)
              (leaf "clip-to-geometry" true)
            ])

            (plain "binds" [
              # You can also use a shell:
              (plain "Print" [
                (leaf "spawn" [
                  "bash"
                  "-c"
                  ''grim -g "$(seto -r)" - | wl-copy -t image/png''
                ])
              ])

              (plain "Alt+G" [
                (leaf "spawn" [
                  "bash"
                  "-c"
                  "ydotool mousemove -a $(seto -f $'%x %y') && ydotool click 0xC0"
                ])
              ])

              # Example volume keys mappings for PipeWire & WirePlumber.
              (plain "XF86MonBrightnessUp"
                [ (leaf "spawn" [ "brightnessctl" "set" "+5%" ]) ])
              (plain "XF86MonBrightnessDown"
                [ (leaf "spawn" [ "brightnessctl" "set" "5%-" ]) ])

              (plain "XF86AudioRaiseVolume"
                [ (leaf "spawn" [ "pamixer" "-i" "5" ]) ])
              (plain "XF86AudioLowerVolume"
                [ (leaf "spawn" [ "pamixer" "-d" "5" ]) ])

              (plain "Alt+Shift+C" [ (flag "close-window") ])

              (plain "Alt+H" [ (flag "focus-column-or-monitor-left") ])
              (plain "Alt+L" [ (flag "focus-column-or-monitor-right") ])

              (plain "Alt+Shift+H"
                [ (flag "move-column-left-or-to-monitor-left") ])
              (plain "Alt+Shift+L"
                [ (flag "move-column-right-or-to-monitor-right") ])

              (plain "Alt+0" [ (leaf "focus-workspace" 10) ])
              (plain "Alt+1" [ (leaf "focus-workspace" 1) ])
              (plain "Alt+2" [ (leaf "focus-workspace" 2) ])
              (plain "Alt+3" [ (leaf "focus-workspace" 3) ])
              (plain "Alt+4" [ (leaf "focus-workspace" 4) ])
              (plain "Alt+5" [ (leaf "focus-workspace" 5) ])
              (plain "Alt+6" [ (leaf "focus-workspace" 6) ])
              (plain "Alt+7" [ (leaf "focus-workspace" 7) ])
              (plain "Alt+8" [ (leaf "focus-workspace" 8) ])
              (plain "Alt+9" [ (leaf "focus-workspace" 9) ])
              (plain "Alt+Shift+0" [ (leaf "move-column-to-workspace" 10) ])
              (plain "Alt+Shift+1" [ (leaf "move-column-to-workspace" 1) ])
              (plain "Alt+Shift+2" [ (leaf "move-column-to-workspace" 2) ])
              (plain "Alt+Shift+3" [ (leaf "move-column-to-workspace" 3) ])
              (plain "Alt+Shift+4" [ (leaf "move-column-to-workspace" 4) ])
              (plain "Alt+Shift+5" [ (leaf "move-column-to-workspace" 5) ])
              (plain "Alt+Shift+6" [ (leaf "move-column-to-workspace" 6) ])
              (plain "Alt+Shift+7" [ (leaf "move-column-to-workspace" 7) ])
              (plain "Alt+Shift+8" [ (leaf "move-column-to-workspace" 8) ])
              (plain "Alt+Shift+9" [ (leaf "move-column-to-workspace" 9) ])

              (plain "Alt+R" [ (flag "switch-preset-column-width") ])
              (plain "Alt+F" [ (flag "maximize-column") ])
              (plain "Alt+C" [ (flag "center-column") ])

              (plain "Alt+N" [ (leaf "set-column-width" "-10%") ])
              (plain "Alt+M" [ (leaf "set-column-width" "+10%") ])

              (plain "Alt+Shift+N" [ (leaf "set-window-height" "-10%") ])
              (plain "Alt+Shift+M" [ (leaf "set-window-height" "+10%") ])

              (lib.optional (conf ? terminal) (plain "Alt+Shift+Return"
                [ (leaf "spawn" [ "${conf.terminal}" ]) ]))

              (lib.optional (conf ? launcher)
                (plain "Alt+S" [ (leaf "spawn" [ "${conf.launcher}" ]) ]))
            ])
          ];
        };
      };
    };
}
