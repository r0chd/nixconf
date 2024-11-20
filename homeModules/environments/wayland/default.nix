{
  pkgs,
  lib,
  config,
  ...
}:
let
  username = "unixpariah"; # Temporary fix
in
{
  imports = [
    ./hyprland
    ./sway
    ./niri
  ];

  config = lib.mkIf (config.window-manager.enable && config.window-manager.backend == "Wayland") {
    environment = {
      loginShellInit =
        # bash
        ''
          if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
          ${
            (
              if config.window-manager.name == "sway" then
                "exec sway --unsupported-gpu"
              else
                config.window-manager.name
            )
          }
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

    home-manager.users.${username} = {
      home = {
        packages = with pkgs; [
          wl-clipboard
          wayland
        ];
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          WLR_NO_HARDWARE_CURSORS = "1";
        };
      };
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
        config.common.default = "*";
      };
    };
  };
}
