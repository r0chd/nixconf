{
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "unixpariah"; # Temporary fix
in
{
  config = lib.mkIf (config.window-manager.enable && config.window-manager.name == "i3") {
    services.xserver = {
      windowManager.i3.enable = true;
    };

    home-manager.users.${username} = {
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };
}
