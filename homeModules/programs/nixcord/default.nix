{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    discord.vencord.package = pkgs.vencord;
    vesktop.enable = false;
    discord.enable = false;
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
}
