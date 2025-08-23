{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.vesktop;
in
{
  config = {
    programs.vesktop = {
      settings = {
        frameless = true;
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        plugins = {
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          alwaysAnimate.enable = true;
          anonymiseFileNames = {
            enable = true;
            anonymiseByDefault = true;
          };
          fakeNitro.enable = true;
          fakeProfileThemes.enable = true;
          translate.enable = true;
        };
      };
    };

    home.persist.directories = lib.optionals cfg.enable [
      ".config/Vencord"
      ".config/vesktop"
    ];
  };
}
