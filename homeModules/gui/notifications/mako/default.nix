{ config, lib, ... }:
let
  inherit (config) colorscheme;
in
{
  config = lib.mkIf (config.notifications.enable && config.notifications.program == "mako") {
    services.mako =
      let
        inherit (colorscheme) background1 accent2;
      in
      {
        enable = true;
        backgroundColor = "#${background1}FF";
        borderColor = "#${accent2}FF";
        defaultTimeout = 0;
        borderRadius = 5;
      };
  };
}
