{ lib, config, ... }:
{
  config = lib.mkIf (config.terminal.enable && config.terminal.program == "foot") {
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
