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
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (cfg.session == "Wayland") {

    environment = {
      systemPackages = [
        (pkgs.writeShellScriptBin "gamescope-session-uwsm" ''
          #!/bin/bash
          gamescope --mangoapp -e --force-grab-cursor -- steam -steamdeck -steamos3 &
          GAMESCOPE_PID=$!

          FINALIZED="I'm here" WAYLAND_DISPLAY=gamescope-0 uwsm finalize

          wait $GAMESCOPE_PID
        '')
      ];
      loginShellInit = lib.mkIf (!config.system.displayManager.enable || config.specialisation != { }) ''
        if uwsm check may-start && uwsm select; then
            exec uwsm start default
        fi
      '';
      variables = {
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "0";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
    };

    xdg.portal = {
      xdgOpenUsePortal = true;
      wlr = {
        enable = lib.mkForce true;
        settings = {
          screencast = {
            chooser_cmd = "${inputs.seto.packages.${pkgs.system}.default}/bin/seto -f %o";
            chooser_type = "simple";
          };
        };
      };
    };

    programs = {
      xwayland.enable = true;
      uwsm = {
        enable = true;
        waylandCompositors.Hyprland = {
          prettyName = "Hyprland";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
        waylandCompositors.sway = {
          prettyName = "Sway";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/sway";
        };
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/niri-session";
        };
        waylandCompositors.gamescope = {
          prettyName = "Gamescope";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/gamescope-session-uwsm";
        };
      };
    };
  };
}
