{ conf, lib, username }:
let inherit (conf) colorscheme;
in {
  config = lib.mkIf
    (conf.notifications.enable && conf.notifications.program == "mako") {
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
