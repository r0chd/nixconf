{
  lib,
  config,
  username,
  ...
}:
{
  config = lib.mkIf (config.window-manager.enable && config.window-manager.name == "i3") {
    home-manager.users.${username} = {
      xsession.windowManager.i3 = {
        enable = true;
      };
    };
  };
}
