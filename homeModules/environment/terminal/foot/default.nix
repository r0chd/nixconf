{ lib, config, ... }:
let
  cfg = config.environment.terminal;
in
{
  config = lib.mkIf (cfg.enable && cfg.program == "foot") {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
        };
        cursor = {
          color = "111111 dcdccc";
        };
      };
    };
  };
}
