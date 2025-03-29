{ config, ... }:
let
  cfg = config.environment.terminal;
in
{
  programs.foot = {
    enable = cfg.enable && cfg.program == "foot";
    settings = {
      main.term = "xterm-256color";
    };
  };
}
