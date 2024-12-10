{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (config.window-manager.enable && config.window-manager.backend == "Wayland") {
    environment = {
      loginShellInit = ''
        if uwsm check may-start && uwsm select; then
            exec uwsm start ${lib.toLower config.window-manager.name}.desktop
        fi
      '';
      variables = {
        XDG_SESSION_TYPE = "wayland";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "0";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors."${config.window-manager.name}" = {
        prettyName = "${config.window-manager.name}";
        comment = "Compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/${config.window-manager.name}";
      };
    };
  };
}
