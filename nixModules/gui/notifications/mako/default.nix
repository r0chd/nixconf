{ config, lib, username, ... }:
let inherit (config) colorscheme;
in {
  config = lib.mkIf
    (config.notifications.enable && config.notifications.program == "mako") {
      home-manager.users."${username}".services.mako =
        let inherit (colorscheme) background1 accent2;
        in {
          enable = true;
          backgroundColor = "#${background1}FF";
          borderColor = "#${accent2}FF";
          defaultTimeout = 10000;
          borderRadius = 5;
        };
    };
}
