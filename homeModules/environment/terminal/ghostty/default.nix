{
  pkgs,
  inputs,
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
      packages = with pkgs; [ inputs.ghostty.packages.${system}.default ];
      file.".config/ghostty/config".text = ''
        font-size = 9
        font-family = "JetBrainsMono Nerd Font Mono"

        window-decoration = false

        background-opacity = 0.0
        background = #000000

        confirm-close-surface = false
      '';
    };
  };
}
