{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.environment.terminal;
in
{
  config = lib.mkIf (cfg.enable && cfg.program == "ghostty") {
    home = {
      packages = with pkgs; [ ghostty ];
      file.".config/ghostty/config".text = ''
        font-size = 9
        font-family = "JetBrainsMono Nerd Font Mono"

        window-decoration = false
        gtk-adwaita = false

        background-opacity = 0.0
        background = #000000

        confirm-close-surface = false
      '';
    };
  };
}
