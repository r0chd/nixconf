{
  lib,
  config,
  pkgs,
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
      loginShellInit = ''
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
      wlr.enable = lib.mkForce true;
    };

    programs.uwsm = {
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
        binPath = "/run/current-system/sw/bin/niri";
      };
    };
  };
}
