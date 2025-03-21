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
      discord.vencord.package = pkgs.vencord;
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

    home.persist.directories = [
      ".config/Vencord"
      ".config/vesktop"
      ".config/discord"
    ];
  };
}
