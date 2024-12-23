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
  config = lib.mkIf (cfg.session == "Gaming") {
    environment = {
      systemPackages = with pkgs; [
        (writeShellScriptBin "steam-gamescope-run" ''
          gamescope --steam --expose-wayland -- steam -tenfoot -pipewire-dmabuf &
          uwsm finalize FINALIZED="I'm here" WAYLAND_DISPLAY
        '')
      ];
      loginShellInit = ''
        if uwsm check may-start && uwsm select; then
            exec uwsm start default
        fi
      '';
    };

    programs = {
      uwsm = {
        enable = true;
        waylandCompositors.Hyprland = {
          prettyName = "Hyprland";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
        waylandCompositors.gamescope = {
          prettyName = "Gamescope";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/steam-gamescope-run";
        };
      };
      hyprland.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };
  };
}
