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
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        plugins = {
          MessageLogger = {
            enabled = true;
            ignoreSelf = true;
          };
          FakeNitro.enable = true;
        };
      };
    };

    home.persist.directories = lib.optionals cfg.enable [
      ".config/Vencord"
      ".config/vesktop"
    ];
  };
}
