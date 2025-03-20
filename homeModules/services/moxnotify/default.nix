{
  inputs,
  ...
}:
{
  imports = [
    inputs.moxnotify.homeManagerModules.default
    #inputs.moxnotify.homeManagerModules.stylix
  ];

  services.moxnotify.settings.keymaps = {
    ge.action = "last_notification";
    d.action = "dismiss_notification";
    xd.action = "dismiss_notification";
  };
}
