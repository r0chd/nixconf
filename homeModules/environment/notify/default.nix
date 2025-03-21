{
  inputs,
  config,
  lib,
  system_type,
  ...
}:
let
  cfg = config.environment.notify;
in
{
  imports = [
    inputs.moxnotify.homeManagerModules.default
    #inputs.moxnotify.homeManagerModules.stylix
  ];

  options.environment.notify = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = system_type == "desktop";
    };
  };

  config.services.moxnotify = {
    enable = cfg.enable;
    settings.keymaps = {
      ge.action = "last_notification";
      d.action = "dismiss_notification";
      xd.action = "dismiss_notification";
    };
  };
}
