{ lib, config, ... }: {
  config =
    lib.mkIf (config.terminal.enable && config.terminal.program == "foot") {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "${config.font}:size=9";
          };
          colors = { alpha = 0; };
          cursor = { color = "111111 dcdccc"; };
        };
      };
    };
}
