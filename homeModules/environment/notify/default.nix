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
    #settings = {
    #keymaps = {
    #ge.action = "last_notification";
    #d.action = "dismiss_notification";
    #xd.action = "dismiss_notification";
    #};

    #styles = {
    #default = {
    #progress.border = {
    #size = 2;
    #radius = 0;
    #};

    #buttons = {
    #dismiss = {
    #default = {
    #background = "#FFFFFF";
    #width = 20;
    #height = 20;
    #border = {
    #size = 2;
    #radius = 0;
    #};
    #font.size = 10;
    #};
    #hover = {
    #background = "#FFFFFF";
    #width = 20;
    #height = 20;
    #font = {
    #size = 10;
    #};
    #border = {
    #size = 2;
    #radius = 0;
    #};
    #};
    #};
    #action = {
    #default = {
    #background = "#FFFFFF";
    #width = "auto";
    #height = "auto";
    #font.size = 10;
    #border = {
    #size = 2;
    #radius = 0;
    #color = "#FFFFFF";
    #};
    #};
    #hover = {
    #background = "#FFFFFF";
    #width = "auto";
    #height = "auto";
    #font.size = 10;
    #border = {
    #size = 2;
    #radius = 0;
    #color = "#FFFFFF";
    #};
    #};
    #};
    #};

    #icon.border = {
    #size = 2;
    #radius = 0;
    #};

    #border = {
    #size = 2;
    #radius = 0;
    #};
    #};
    #};
    #};
  };
}
