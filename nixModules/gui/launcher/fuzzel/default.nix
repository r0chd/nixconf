{ conf, lib }:
let
  inherit (conf) username colorscheme;
  inherit (colorscheme) special inactive text background1 accent1 accent2;
in {
  config =
    lib.mkIf (conf.launcher.enable && conf.launcher.program == "fuzzel") {
      home-manager.users."${username}".programs.fuzzel = {
        enable = true;
        settings = {
          colors = {
            background = "${background1}FF";
            text = "${text}FF";
            input = "${text}FF";
            border = "${accent1}FF";
            selection = "${inactive}FF";
            selection-text = "${accent2}FF";
            selection-match = "${special}FF";
            match = "${special}FF";
          };
        };
      };
    };
}
