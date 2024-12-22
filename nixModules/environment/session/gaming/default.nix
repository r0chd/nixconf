{ lib, config, ... }:
let
  cfg = config.environment;
in
{
  config = lib.mkIf (cfg.session == "Gaming") {
    environment.loginShellInit = ''
      if uwsm check may-start && uwsm select; then
          exec uwsm start default
      fi
    '';

    programs = {
      uwsm = {
        enable = true;
        waylandCompositors.Hyprland = {
          prettyName = "Hyprland";
          comment = "Compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
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
