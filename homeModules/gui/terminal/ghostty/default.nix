{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.terminal.enable && config.terminal.program == "ghostty") {
    home = {
      packages = with pkgs; [ inputs.ghostty.packages.${system}.default ];
      file.".config/ghostty/config".text = ''
        font-size = 10
        font-family = "${config.font}"

        window-decoration = false

        background-opacity = 0.0
        background = #000000

        confirm-close-surface = false
      '';
    };
  };
}
