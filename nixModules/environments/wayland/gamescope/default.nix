{ lib, config, ... }:
let
  cfg = config.window-manager;
in
{
  config = lib.mkIf (cfg.enable && cfg.name == "gamescope") {
    programs = {
      hyprland.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };
  };
}
