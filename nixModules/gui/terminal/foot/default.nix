{ lib, conf }:
let inherit (conf) username font;
in {
  config = lib.mkIf (conf.terminal.enable && conf.terminal.program == "foot") {
    home-manager.users."${username}".programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "${font}:size=9";
        };
        colors = { alpha = 0; };
        cursor = { color = "111111 dcdccc"; };
      };
    };
  };
}
