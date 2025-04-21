{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.nixcord;
in
{
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  config = {
    programs.nixcord = {
      enable = cfg.vesktop.enable || cfg.discord.enable;
      discord.enable = lib.mkDefault false;
      config = {
        frameless = true;
        plugins = {
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

    home.persist.directories =
      [ ".config/Vencord" ]
      ++ lib.optionals cfg.vesktop.enable [ ".config/vesktop" ]
      ++ lib.optionals cfg.discord.enable [ ".config/discord" ];
  };
}
