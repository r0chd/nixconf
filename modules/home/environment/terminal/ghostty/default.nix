{ config, ... }:
let
  cfg = config.environment.terminal;
in
{
  programs.ghostty = {
    enable = cfg.enable && cfg.program == "ghostty";
    settings = {
      window-decoration = false;
      confirm-close-surface = false;
    };
  };
}
