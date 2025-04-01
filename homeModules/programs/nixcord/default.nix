{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  options.programs = {
    discord.enable = lib.mkEnableOption "discord";
    vesktop.enable = lib.mkEnableOption "vesktop";
  };

  config = {
    programs.nixcord = {
      enable = config.programs.vesktop.enable || config.programs.discord.enable;
      vesktop.enable = config.programs.vesktop.enable;
      discord.enable = config.programs.discord.enable;
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
      ++ lib.optionals config.programs.vesktop.enable [ ".config/vesktop" ]
      ++ lib.optionals config.programs.discord.enable [ ".config/discord" ];
  };
}
