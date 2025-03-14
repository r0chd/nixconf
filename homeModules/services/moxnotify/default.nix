{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.moxnotify.homeManagerModules.default
    inputs.moxnotify.homeManagerModules.stylix
  ];

  home.packages = [ pkgs.moxnotify ];

  services.moxnotify = {
    settings = {
      default_timeout = 5;
      styles.default = {
        buttons = {
          dismiss = {
            default = {
              background_color = config.lib.stylix.colors.withHashtag.base08;
              border_color = config.lib.stylix.colors.withHashtag.base08;
            };
            hover = {
              background_color = config.lib.stylix.colors.withHashtag.base07;
              border_color = config.lib.stylix.colors.withHashtag.base07;
            };
          };
          action = {
            default = {
              background_color = config.lib.stylix.colors.withHashtag.base08;
              border_color = config.lib.stylix.colors.withHashtag.base08;
            };
            hover = {
              background_color = config.lib.stylix.colors.withHashtag.base08;
              border_color = config.lib.stylix.colors.withHashtag.base08;
            };
          };
        };

        border.radius = 5;
      };
    };
  };
}
